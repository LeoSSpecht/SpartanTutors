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
    private var initial_time = 8
    @Published private (set) var studentSessions: Array<Session> = []
    
    init(){
        retrieveStudentSessions()
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
    
    func changeSessionStatus(session_id: String, session_status: String) -> Bool{
        var newStatus: [String:Any] = [
            "status": session_status
        ]
        switch session_status {
            case "Approved":
                newStatus["paid"] = true
            case "Canceled":
                newStatus["refunded"] = true
            default:
                print("do nothing")
        }
        let ref = db.collection("Sessions")
        var result = false
        ref.document(session_id).updateData(newStatus) { (err) in
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
}

