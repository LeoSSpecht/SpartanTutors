//
//  TutorSessionViewModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/30/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class TutorAllSessionsViewModel: ObservableObject{
    @Published private (set) var model = tutorSessionsModel()
    @Published private (set) var studentNames: [String:String] = [:]
    private var tutor_id:String = ""
    private var db = Firestore.firestore()
    private var initial_time = 8
    
    func initiate(_ id: String){
        tutor_id = id
        retrieveStudentSessions()
        retrieveStudentNames()
    }
    
    var specific_tutor_sessions:Array<Session> {
        model.studentSessions.filter{
            $0.tutor_uid == self.tutor_id
        }
    }
    
    func retrieveStudentSessions(){
        let ref = db.collection("Sessions")
        ref.addSnapshotListener(){(querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let studentSessions = documents.map { (queryDocumentSnapshot) -> Session in
                var dict = queryDocumentSnapshot.data()
                dict["id"] = queryDocumentSnapshot.documentID
                let stamp: Timestamp = dict["date"] as! Timestamp
                dict["date"] = stamp.dateValue()
                return Session(dict)
            }
//            print(documents)
            print(studentSessions)
            self.model.update_session(new: studentSessions)
        }
    }
    
    func retrieveStudentNames(){
        let ref = db.collection("users").whereField("role", isEqualTo: "student")
        ref.addSnapshotListener(){(querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            documents.forEach{
                self.studentNames[$0.documentID] = $0["name"] as? String
            }
        }
    }
}

struct tutorSessionsModel{
    private (set) var studentSessions: Array<Session> = []
    
    mutating func update_session(new:Array<Session>){
        self.studentSessions = new
    }
}
