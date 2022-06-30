//
//  bookSessionViewModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/23/22.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class bookStudentSession: ObservableObject {
    private var db = Firestore.firestore()
    private let student_id:String
    
    @Published var model = sessionBookerData()
    @Published var classSelection:String = ""
    @Published var tutorSelection:TutorClass = TutorClass(id: "Any", tutorName: "Any", classes: [])
    @Published var tutorNames = "Any"
    @Published var dateSelection:Date = Date()
    @Published var sessionSelections:Array<String>?
    
    init(student_id:String){
        self.student_id = student_id
        get_all_tutors()
        getTutorSchedules()
    }
    
//  MARK: GETTERS
    var available_times:Array<Array<String>> {
        model.available_times
    }
    
    var tutors:Array<TutorClass> {
        model.tutors_for_class
    }
    
    var classes_:Array<String>{
        Array(self.model.all_classes)
    }

//  MARK: UPDATING FUNCTIONS
    func update_tutor_selection(){
        //        Changes the tutor for tutors available for that class
        tutorSelection = TutorClass(id: "Any", tutorName: "Any", classes: [])
        model.update_tutors_for_class(class_selection: classSelection)
    }
    
    func update_times(){
        model.update_available_times(tutor: tutorSelection.id, date: dateSelection, college_class: classSelection)
//        Set the current time selection for the first one
        if !self.model.available_times.isEmpty{
            sessionSelections = self.model.available_times[0]
        }
        else{
            sessionSelections = nil
        }
    }

    func build_all_classes(){
        var allClasses: Set<String> = []
        for tutor in model.all_tutors{
            for u_class in tutor.classes{
                allClasses.insert(u_class)
            }
        }
        model.update_classes(new_classes: allClasses)
    }
    
//  MARK: DATABASE ACCESS
    func get_all_tutors(){
        let ref = db.collection("users")
        ref.whereField("role", isEqualTo: "tutor")
            .getDocuments() { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                let allTutors = documents.map { (queryDocumentSnapshot) -> TutorClass in
                    let dict = queryDocumentSnapshot.data()
                    return TutorClass(
                        id: queryDocumentSnapshot.documentID,
                        tutorName: dict["name"] as! String,
                        classes: dict["classes"] as! Array<String>)
                }
                print(allTutors)
                self.model.update_tutors(new_tutors: allTutors)
                self.build_all_classes()
                self.classSelection = self.model.all_classes.first ?? ""
            }
    }
    
    func getTutorSchedules(){
        let ref = db.collection("tutor_schedules")
        ref.getDocuments(){ (querySnapshot, err) in
//        ref.addSnapshotListener{ (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let new_schedules = documents.map { (queryDocumentSnapshot) -> TutorSchedule in
                let dict = queryDocumentSnapshot.data()
                return TutorSchedule(dict,id_i: queryDocumentSnapshot.documentID)
            }
            self.model.update_tutor_times(new_times: new_schedules)
            self.model.update_available_times(college_class: self.classSelection)
            self.model.update_tutors_for_class(class_selection: self.classSelection)
            if !self.model.available_times.isEmpty{
                self.sessionSelections = self.model.available_times[0]
            }
            else{
                self.sessionSelections = nil
            }
        }
    }
    
    func updateTutorSchedule(tutor_schedule:TutorSchedule) -> Bool{
        let ref = db.collection("tutor_schedules").document(tutor_schedule.id)
        var updated = false
        ref.updateData(tutor_schedule.schedule){(err) in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                updated = true
            }
        }
        return updated
    }
    
    typealias CompletionHandler = (_ success:Bool, _ schedule: TutorSchedule) -> Void
    func getSpecificTutorTime(tutor_uid: String, complete: @escaping CompletionHandler){
        let ref = db.collection("tutor_schedules").document(tutor_uid)
        ref.getDocument{ (querySnapshot, err) in
            guard let documents = querySnapshot?.data() else {
                print("No documents")
                complete(false,TutorSchedule([:],id_i:""))
                return
            }
            let dict = documents
            complete(true,TutorSchedule(dict,id_i: querySnapshot!.documentID))
        }
    }

// MARK: Helper functions
    func createSessionObject(){
        var content:[String:Any] = [
            "id" : "",
            "tutor_uid" : sessionSelections![1],
            "date" : dateSelection,
            "time_slot" : sessionSelections![2],
            "college_class" : classSelection
        ]
        content["student_uid"] = student_id
        let sessionToBook = Session(content)
        bookSession(sessionToBook)
//        if bookSession(sessionToBook){
//            retrieveStudentSessions()
//        }
    }
    

    
    
    
    func update_single_time(session_time_slot:String,tutor_time_slot:String) -> String?{
        let str = session_time_slot
        let tutor_updated_str = tutor_time_slot
        var final_tutor_schedule = ""
        for time in 0..<session_time_slot.count{
            let index = str.index(str.startIndex, offsetBy: time)
            let index_tutor = str.index(tutor_updated_str.startIndex, offsetBy: time)
            if str[index] == "2" && tutor_updated_str[index_tutor] != "1"{
                return nil
            }
            else if str[index] == "2" && tutor_updated_str[index_tutor] == "1"{
                final_tutor_schedule = final_tutor_schedule + "2"
            }
            else if str[index] != "2"{
                final_tutor_schedule = final_tutor_schedule + String(tutor_updated_str[index_tutor])
            }
        }
        return final_tutor_schedule
    }
    
    func bookSession(_ session: Session) -> Bool{
//        Check if tutor is really available
        let myGroup = DispatchGroup()
        myGroup.enter()
        var updated_scheduled:TutorSchedule = TutorSchedule([:],id_i: "")
        self.getSpecificTutorTime(tutor_uid: session.tutor_uid,complete: { success, schedule in
            updated_scheduled = schedule
            myGroup.leave()
        })
        
        myGroup.notify(queue: .main) {
            var isAvailable = true
            let date_convert:String = "\(Int((((session.date.timeIntervalSince1970/60)/60)/24)))"
            var final_tutor_schedule = ""
            if(updated_scheduled.schedule[date_convert] != nil){
                let str = session.time_slot
                let tutor_updated_str = updated_scheduled.schedule[date_convert]!
                
                if let schedule = self.update_single_time(session_time_slot: str, tutor_time_slot: tutor_updated_str){
                    final_tutor_schedule = schedule
                }
                else{
                    isAvailable = false
                }
            }
    
    
            if isAvailable {
                //Create session
                var final_session = session
                let ref = self.db.collection("Sessions")
                let docId = ref.document().documentID
                var created_session = false
                do {
                    final_session.id = docId
                    try self.db.collection("Sessions").document(docId).setData(from: final_session)
                    created_session = true
                } catch let error {
                    print("Error writing session to Firestore: \(error)")
                }
    //            Updates tutor
                if created_session{
                //        Changes tutor schedule
                    updated_scheduled.schedule[date_convert] = final_tutor_schedule
                    print("Session was created")
                    print(updated_scheduled)
                    self.updateTutorSchedule(tutor_schedule: updated_scheduled)
                }
            }
        }
        return false
    }
}
