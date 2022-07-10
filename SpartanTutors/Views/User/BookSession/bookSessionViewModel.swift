//
//  bookSessionViewModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/23/22.
//
import Foundation
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift
class bookStudentSession: ObservableObject {
//    settings.isPersistenceEnabled = false
    private var db =  Firestore.firestore()
    private let student_id:String
    
    @Published var model = sessionBookerData()
    @Published var tutorSelection:TutorSummary = TutorSummary(id: "Any", tutorName: "Any")
    @Published var dateSelection:Date = Date()
    @Published var sessionSelections:sessionTime?
    @Published var selectedClass:String = ""
    @Published var finishedLoading = false
    
    //ID -> Schedule
    
    init(student_id:String){
        self.student_id = student_id
        get_all_tutors()
    }
    
//  MARK: GETTERS
    var classes_:Array<String>{
        self.model.all_classes
    }
    
    var available_times:Array<sessionTime>{
        model.available_times
    }
    
    var tutors:Array<TutorSummary> {
        if let av = model.classes_dict[selectedClass]{
            return av.map{ (tutor_id) -> TutorSummary in
                return TutorSummary(id: tutor_id, tutorName: model.id_schedule_dict[tutor_id]!.tutorName)
            }
            
        }
        return []
    }
    
//  MARK: UPDATING FUNCTIONS
    func update_times(){
        model.create_available_times(tutor: tutorSelection.id, date: dateSelection, college_class: selectedClass)
        if !self.model.available_times.isEmpty{
            self.choose_session(0)
        }
        else{
            sessionSelections = nil
        }
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
                
                var dataDict = [String:TutorSchedule]()
                var classes_dict = [String:Array<String>]()
                //Creates a dictionary with id -> TutorSchedule, but empyt schedule
                documents.forEach{ queryDocumentSnapshot in
                    let doc_id = queryDocumentSnapshot.documentID
                    let dict = queryDocumentSnapshot.data()
                    let classes = dict["classes"] as! Array<String>
                    let name = dict["name"] as! String
                    dataDict[doc_id] = TutorSchedule(id: doc_id, available_classes: classes, name: name)
                    //Creates a dict with all the classes -> ID of the tutors for that class
                    classes.forEach{ available_class in
                        if classes_dict[available_class] == nil{
                            classes_dict[available_class] = []
                        }
                        classes_dict[available_class]?.append(doc_id)
                    }
                }
                
                self.model.update_id_schedule(new: dataDict, classes_available: classes_dict)
                self.selectedClass = self.model.all_classes.first ?? "Bug"
                self.generateTutorSchedules()
            }
    }
    
    func choose_session(_ ind: Int){
        self.sessionSelections = self.model.available_times[ind]
        self.model.choose_session(ind)
    }
    
    func generateTutorSchedules(){
        let ref = db.collection("tutor_schedules")
//        ref.getDocuments{ (querySnapshot, err) in
        ref.addSnapshotListener{ (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            print("Fetched Times")
            documents.forEach{ queryDocumentSnapshot in
                let dict = queryDocumentSnapshot.data()
                let doc_id = queryDocumentSnapshot.documentID
                if self.model.id_schedule_dict[doc_id] != nil{
                    self.model.update_tutor_schedule(new_schedule: dict, id: doc_id)
                }
            }
            
            self.selectedClass = self.model.all_classes.first ?? "Bug"
            
            // Gets the first time available for that date
            if self.selectedClass != "Bug"{
                self.model.create_available_times(tutor: self.tutorSelection.id ,date: self.dateSelection, college_class: self.selectedClass)
            }

            if !self.model.available_times.isEmpty{
                self.choose_session(0)
            }
            else{
                self.sessionSelections = nil
            }
            self.finishedLoading = true
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
    
    typealias CompletionHandler = (_ success:Bool, _ schedule: TutorSchedule?) -> Void
    func getSpecificTutorTime(tutor_uid: String, complete: @escaping CompletionHandler){
        let ref = db.collection("tutor_schedules").document(tutor_uid)
        ref.getDocument{ (querySnapshot, err) in
            guard let documents = querySnapshot?.data() else {
                print("No documents")
                complete(false,nil)
                return
            }
            let dict = documents
            var schedule = TutorSchedule(id: querySnapshot!.documentID, available_classes: [], name: "")
            schedule.update_schedule(dict)
            complete(true,schedule)
        }
    }

// MARK: Helper functions
    func createSessionObject(){
        var content:[String:Any] = [
            "id" : "",
            "tutor_uid" : sessionSelections?.tutor as Any,
            "date" : sessionSelections?.sessionDate as Any,
            "time_slot" : sessionSelections?.timeframe as Any,
            "college_class" : selectedClass
        ]
        content["student_uid"] = student_id
        let sessionToBook = Session(content)
        bookSession(sessionToBook)
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
        var updated_scheduled:TutorSchedule = TutorSchedule(id: "", available_classes: [], name: "")
        self.getSpecificTutorTime(tutor_uid: session.tutor_uid,complete: { success, schedule in
            if let s = schedule{
                updated_scheduled = s
            }
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
