//
//  sessionModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import Foundation


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct sessionScheduler{
    private var db = Firestore.firestore()
    
    mutating func bookSession(_ session: Session) -> Bool{
//        Books session
        var final_session = session
        let ref = db.collection("Sessions")
        let docId = ref.document().documentID
        
        do {
            final_session.id = docId
            try db.collection("Sessions").document(docId).setData(from: final_session)
            return true
        } catch let error {
            print("Error writing session to Firestore: \(error)")
            return false
        }
        
//        Changes tutor schedule
    }
    
    func retrieveStudentSessions(student_uid: String) -> Array<Session>{
        var studentSessions: Array<Session> = []
        let ref = db.collection("Sessions")
        ref.whereField("student_uid", isEqualTo: student_uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        var dict = document.data()
                        dict["id"] = document.documentID
                        let stamp: Timestamp = dict["date"] as! Timestamp
                        dict["date"] = stamp.dateValue()
                        studentSessions.append(
                            Session(dict)
                        )
                        print("\(document.documentID) => \(document.data())")
                    }
                }
        }
        return studentSessions
    }
    
    func changeSessionStatus(session_id: String, session_status: String) -> Bool{
        var newStatus: [String:Any] = [
            "status": session_status
        ]
        switch session_status {
            case "Approved":
                newStatus["payed"] = true
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

struct Session: Codable, Identifiable{
    var id: String = ""
    var student_uid:String
    var tutor_uid:String
    var date: Date
    var time_slot: String
    var college_class: String
//        Possible: Pending, Approved, Canceled
    var status: String = "Pending"
    var payed: Bool = false
    var refunded: Bool = false
    
    init(_ content: [String: Any]){
        id = content["id"] as! String
        student_uid = content["student_uid"] as! String
        tutor_uid = content["tutor_uid"] as! String
        date = content["date"] as! Date
        time_slot = content["time_slot"] as! String
        college_class = content["college_class"] as! String
        if((content["status"]) != nil){
            status = content["status"] as! String
        }
        if((content["payed"]) != nil){
            payed = content["payed"] as! Bool
        }
        if((content["refunded"]) != nil){
            refunded = content["refunded"] as! Bool
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case student_uid
        case tutor_uid
        case date
        case time_slot
        case status
        case payed
        case refunded
        case college_class
        case id
    }
}
