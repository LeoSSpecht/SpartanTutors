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
    @Published var isFirstSignIn:Bool = false
    @Published var isTutorApproved:Bool = false
    @Published var isTutorFirstSignIn:Bool = false
    @Published var isLoading:Bool = true
    @Published var error:Bool = false
    func getRole(uid:String){
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    self.userRole = data["role"] as? String ?? ""
                    self.isFirstSignIn = data["firstSignIn"] as? Bool ?? false
                    if self.userRole == "tutor"{
                        //Check for tutor specific variables
                        if data["approved"] != nil {
                            self.isTutorApproved = (data["approved"] as? Bool)!
                        }
                        if data["TutorFirstSignIn"] != nil{
                            self.isTutorFirstSignIn = (data["TutorFirstSignIn"] as? Bool)!
                        }
                    }
                    self.isLoading = false
                }
            } else {
                self.isLoading = false
                self.error = true
                print("Document does not exist")
            }
        }
    }
}
