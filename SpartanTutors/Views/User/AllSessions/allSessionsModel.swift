//
//  sessionModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class AllSessionsModel: ObservableObject{
    private var db = Firestore.firestore()
    private var initial_time = 8
    private var listeners: [ListenerRegistration] = []
    @Published private (set) var studentSessions: Array<Session> = []
    @Published private (set) var tutors: Array<TutorSummary> = []
    
    private var student_id:String
    
    init(uid: String){
        student_id = uid
        retrieveStudentSessions()
        getAllTutors()
    }
    
    deinit{
        print("Ran deinit")
        for i in self.listeners.indices{
            self.listeners[i].remove()
        }
    }
    
    var confirmed: Array<Session>{
        self.studentSessions.filter{ session in
            session.status == "Approved" && session.date >= Date()
        }
        .sorted{
            $0.date > $1.date
        }
    }

    var other_Sessions: Array<Session> {
        self.studentSessions.filter{session in
            session.status != "Approved" || session.date < Date()
        }.sorted{
            $0.date > $1.date
        }
        .sorted{
            $0.status != "Canceled" && $1.status == "Canceled"
        }
    }
    
    func retrieveStudentSessions(){
        let ref = db.collection("Sessions")
        self.studentSessions.removeAll()
        let listen = ref.whereField("student_uid", isEqualTo: student_id)
            .addSnapshotListener() { (querySnapshot, err) in
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
        self.listeners.append(listen)
    }
    
    func getAllTutors(){
        let ref = db.collection("users")
        let listen = ref.whereField("role", isEqualTo: "tutor")
            .addSnapshotListener() { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                let allTutors = documents.map { (queryDocumentSnapshot) -> TutorSummary in
                    var dict = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    dict["id"] = id
                    let encoded = try! JSONSerialization.data(withJSONObject: dict, options: [])
                    let tutor_object = try! JSONDecoder().decode(TutorSummary.self, from: encoded)
//                    tutor_object.id = id
                    return tutor_object
                }
                self.tutors = allTutors
            }
        self.listeners.append(listen)
    }
    
    func cancel_session(session: Session){
        let new_status = [
            "status": "Canceled",
        ]
        updateCanceledSchedule(date: session.date, sessionTimeFrame: session.time_slot, tutor_id: session.tutor_uid)
        let ref = db.collection("Sessions")
        ref.document(session.id).updateData(new_status){ (err) in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func updateCanceledSchedule(date:Date,sessionTimeFrame:String,tutor_id:String){
        let day = date.to_int_format()
        get_specific_tutor_schedule(tutor_id: tutor_id, day: day, session_schedule: Timeframe(sessionTimeFrame)){ new_schedule in
            self.db.collection("tutor_schedules").document(tutor_id).updateData(
                [day:new_schedule as Any]
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
    
    func get_specific_tutor_schedule(tutor_id:String, day: String, session_schedule: Timeframe, completion: @escaping (_: String?) -> Void){
        db.collection("tutor_schedules").document(tutor_id).getDocument{(document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                if let schedule = data[day]{
                    let tutor_new_time = self.change_session_time(session_time: session_schedule, tutor_schedule: Timeframe((schedule as? String)!))
                    completion(tutor_new_time.to_string)
                }
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    func change_session_time(session_time:Timeframe, tutor_schedule: Timeframe) -> Timeframe{
        var tutor = tutor_schedule
        for i in session_time.data.indices{
            if session_time.data[i] == 2{
                tutor.data[i] = 1
            }
        }
        return tutor_schedule
    }
}

