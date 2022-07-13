//
//  allSessionsViewModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/26/22.
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class AdminAllSessions: ObservableObject{
    private var db = Firestore.firestore()
    @Published private (set) var studentSessions: Array<Session> = []
    
    @Published var tutorSchedules = [String:TutorScheduleModel]()
    @Published var studentNames = [String:String]()
    @Published var tutorNames = [String:String]()
    
    init(){
        retrieveStudentSessions()
        getAllTutorSchedules()
        retrieveNames(role: "student")
        retrieveNames(role: "tutor")
    }
    
    func retrieveNames(role:String){
        let ref = db.collection("users").whereField("role", isEqualTo: role)
        ref.addSnapshotListener(){(querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            documents.forEach{
                if role == "student"{
                    self.studentNames[$0.documentID] = $0["name"] as? String
                }
                else{
                    self.tutorNames[$0.documentID] = $0["name"] as? String
                }
            }
        }
    }
    
    func retrieveStudentSessions(){
        let ref = db.collection("Sessions")
        self.studentSessions.removeAll()
        ref.addSnapshotListener(){(querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.studentSessions = documents.map { (queryDocumentSnapshot) -> Session in
                var dict = queryDocumentSnapshot.data()
                dict["id"] = queryDocumentSnapshot.documentID
                let stamp: Timestamp = dict["date"] as! Timestamp
                dict["date"] = stamp.dateValue()
                return Session(dict)
            }
        }
    }
    
    func changeSessionStatus(session: Session, session_status: String) -> Bool{
        var newStatus: [String:Any] = [
            "status": session_status
        ]
        switch session_status {
            case "Approved":
                newStatus["paid"] = true
            case "Canceled":
                newStatus["refunded"] = true
                //Update tutor schedule
                updateCanceledSchedule(date: session.date, sessionTimeFrame: session.time_slot, tutor_id: session.tutor_uid)
            default:
                print("do nothing")
        }
        let ref = db.collection("Sessions")
        var result = false
        ref.document(session.id).updateData(newStatus){ (err) in
            if let err = err {
                print("Error updating document: \(err)")
                result = false
            } else {
                print("Document successfully updated")
                result = true
            }
        }
        return result
    }
    
    func getAllTutorSchedules(){
        db.collection("tutor_schedules").addSnapshotListener{result, err in
            guard let documents = result?.documents else {
                print("Error fetching documents: \(err!)")
                return
            }
            
            var schedules = [String:TutorScheduleModel] ()
            documents.forEach{tutor in
                schedules[tutor.documentID] = TutorScheduleModel(new: tutor.data() as? [String:String] ?? nil)
            }
            self.tutorSchedules = schedules
        }
    }
    
    func updateCanceledSchedule(date:Date,sessionTimeFrame:String,tutor_id:String){
        let day = date.to_int_format()
        
        //Updates the model variable
        for i in sessionTimeFrame.indices{
            if sessionTimeFrame[i] == "2"{
                self.tutorSchedules[tutor_id]!.schedule[day]!.cancel_session_time(ind: i.utf16Offset(in: sessionTimeFrame))
            }
        }
        
        //Converting the array of ints to Array of string
        let schedule_string = self.tutorSchedules[tutor_id]!.schedule[day]!.to_string
        
        db.collection("tutor_schedules").document(tutor_id).updateData(
            [day:schedule_string]
        )
        {(err) in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}

