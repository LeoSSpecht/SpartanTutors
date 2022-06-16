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
