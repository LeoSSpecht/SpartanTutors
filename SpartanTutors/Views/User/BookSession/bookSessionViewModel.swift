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
    private var listeners =  [ListenerRegistration]()
    @Published var model = sessionBookerData()
    @Published var tutorSelection:TutorSummary = TutorSummary(id: "Any", name: "Any", zoom_link: "")
    @Published var dateSelection:Date = Date()
    @Published var sessionSelections:sessionTime?
    @Published var selectedClass:String = ""
    @Published var finishedLoading = false
    
    //ID -> Schedule
    
    init(student_id:String){
        self.student_id = student_id
        get_all_tutors()
    }
    
    deinit{
        for i in self.listeners.indices{
            self.listeners[i].remove()
        }
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
                return TutorSummary(id: tutor_id, name: model.id_schedule_dict[tutor_id]!.tutorName, zoom_link: "")
            }
            
        }
        return []
    }
    
//  MARK: UPDATING FUNCTIONS
    func update_times(){
        model.create_available_times(tutor: tutorSelection.id, date: dateSelection, college_class: selectedClass)
        if !self.model.available_times.isEmpty{
            self.choose_session(self.model.available_times.first!.id)
        }
        else{
            sessionSelections = nil
        }
    }

//  MARK: DATABASE ACCESS
    func get_all_tutors(){
        let ref = db.collection("users")
        ref.whereField("role", isEqualTo: "tutor").whereField("approved", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                var dataDict = [String:TutorSchedule]()
                var classes_dict = [String:Array<String>]()
//                var allTutors = [TutorSummary]()
                //Creates a dictionary with id -> TutorSchedule, but empyt schedule
                documents.forEach{ queryDocumentSnapshot in
                    let doc_id = queryDocumentSnapshot.documentID
                    let dict = queryDocumentSnapshot.data()
                    let classes = dict["classes"] as! Array<String>
                    let name = dict["name"] as! String
                    dataDict[doc_id] = TutorSchedule(id: doc_id, available_classes: classes, name: name)
//                    allTutors.append(TutorSummary(id: doc_id, name: name))
                    //Creates a dict with all the classes -> ID of the tutors for that class
                    classes.forEach{ available_class in
                        if classes_dict[available_class] == nil{
                            classes_dict[available_class] = []
                        }
                        classes_dict[available_class]?.append(doc_id)
                    }
                }
                
//                self.model.update_tutors(new_tutors: allTutors)
                self.model.update_id_schedule(new: dataDict, classes_available: classes_dict)
                self.selectedClass = self.model.all_classes.first ?? "Bug"
                self.generateTutorSchedules()
            }
    }
    
    func choose_session(_ id: Int){
        self.sessionSelections = self.model.choose_session(id)
    }
    
    func generateTutorSchedules(){
        let ref = db.collection("tutor_schedules")
        let listen = ref.addSnapshotListener{ (querySnapshot, err) in
            
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
                self.choose_session(self.model.available_times.first!.id)
            }
            else{
                self.sessionSelections = nil
            }
            self.finishedLoading = true
        }
        self.listeners.append(listen)
    }
    
    func updateTutorSchedule(tutor_schedule:TutorSchedule){
        let ref = db.collection("tutor_schedules").document(tutor_schedule.id)
        ref.updateData(tutor_schedule.schedule_to_string){(err) in
            if let err = err {
                print("Error updating tutor schedule: \(err)")
            } else {
                print("Sucessufuly updated tutor schedule")
            }
        }
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
            "time_slot" : sessionSelections?.timeframe.to_string as Any,
            "college_class" : selectedClass
        ]
        content["student_uid"] = student_id
        let sessionToBook = Session(content)
        bookSession(sessionToBook)
    }
    
    func update_single_time(session_timeframe:Timeframe,tutor_timeframe:Timeframe) -> Timeframe?{
        var tutor_updated_str = tutor_timeframe
        if tutor_updated_str.update_time_for_new_session(session_time: session_timeframe){return tutor_updated_str}
        return nil
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
            let date_convert:String = session.date.to_int_format()
            print(date_convert)
            var final_tutor_schedule = Timeframe()
            if(updated_scheduled.schedule[date_convert] != nil){
                let str = session.time_slot_obj
                let tutor_updated_str = updated_scheduled.schedule[date_convert]!
                
                if let schedule = self.update_single_time(session_timeframe: str, tutor_timeframe: tutor_updated_str){
                    final_tutor_schedule = schedule
                }
                else{
                    isAvailable = false
                }
            }
    
            if isAvailable {
                //Create session
                self.upload_session_to_database(session: session){ uploaded in
                    if uploaded{
                        updated_scheduled.schedule[date_convert] = final_tutor_schedule
                        print("Starting tutor schedule update")
                        self.updateTutorSchedule(tutor_schedule: updated_scheduled)
                    }
                }
            }
        }
        return false
    }
    
    func upload_session_to_database(session: Session, completion: @escaping (_: Bool) -> Void){
        var final_session = session
        let ref = self.db.collection("Sessions")
        let docId = ref.document().documentID
        final_session.id = docId
        self.db.collection("Sessions").document(docId).setData(final_session.generate_dict()){(err) in
            if let err = err {
                print("Error on creating session: \(err)")
                completion(false)
            } else {
                print("Session created")
                completion(true)
            }
        }
    }
    
    
}
