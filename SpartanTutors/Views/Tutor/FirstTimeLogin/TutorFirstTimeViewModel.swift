//
//  TutorFirstTimeViewModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/30/22.
//

import Foundation
import FirebaseFirestore

class TutorCreationModel:ObservableObject{
    @Published var venmo:String = ""
    @Published var zoom_link:String = ""
    
    var both_filled: Bool{
        !venmo.isEmpty && !zoom_link.isEmpty
    }
    private var db = Firestore.firestore()
    
    func updateTutor(uid:String,classes: Array<String>){
        db.collection("users").document(uid).updateData([
            "venmo": venmo,
            "zoom_link": zoom_link,
            "classes": classes,
            "TutorFirstSignIn":false
            ]){ (err) in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
