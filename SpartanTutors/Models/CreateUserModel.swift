//
//  CreateUserModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import Foundation
import FirebaseFirestore

struct UserCreationModel{
    private var db = Firestore.firestore()
    func createUser(uid:String, userInfo: [String:String]){
        db.collection("users").document(uid).setData(
            userInfo
        ) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
