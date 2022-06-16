//
//  getRoleModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import Foundation
import FirebaseFirestore

class getRoleModel: ObservableObject{
    
    private var db = Firestore.firestore()
    @Published var userRole:String = ""

    func getRole(uid:String){
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    self.userRole = data["role"] as? String ?? ""
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
