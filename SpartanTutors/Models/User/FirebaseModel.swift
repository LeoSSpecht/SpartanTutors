//
//  FirebaseModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import Foundation
import FirebaseFirestore

struct FirebaseConnection{
    private var db = Firestore.firestore()
    
    private (set) var user_role:String = ""
    
    func getRole(uid: String){
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    data["role"] as! String
//                    print("data", data)
//                    self.restaurant = data["name"] as? String ?? ""
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    struct User{
        var availableClasess: Array<String>
        var bio: String
        var major: String
        var name: String
        var phone: String
        var role:String
        var venmoUsername:String
        var yearStatus:String
    }
}
