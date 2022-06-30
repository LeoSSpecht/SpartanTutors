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
    
    private var student_id:String
    
    init(uid: String){
        student_id = uid
        retrieveStudentSessions()
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
}
