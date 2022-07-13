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
    @Published private (set) var studentSessions: Array<Session> = []
    @Published private (set) var tutors: Array<TutorSummary> = []
    
    private var student_id:String
    
    init(uid: String){
        student_id = uid
        retrieveStudentSessions()
        getAllTutors()
    }
    
    func retrieveStudentSessions(){
        let ref = db.collection("Sessions")
        self.studentSessions.removeAll()
        ref.whereField("student_uid", isEqualTo: student_id)
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
    }
    
    func getAllTutors(){
        let ref = db.collection("users")
        ref.whereField("role", isEqualTo: "tutor")
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
                    var tutor_object = try! JSONDecoder().decode(TutorSummary.self, from: encoded)
//                    tutor_object.id = id
                    return tutor_object
                }
                self.tutors = allTutors
                print(allTutors)
            }
    }
}

