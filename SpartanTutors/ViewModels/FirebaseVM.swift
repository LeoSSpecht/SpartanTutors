//
//  FirebaseVM.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import Foundation
import SwiftUI


class FirebaseVM: ObservableObject{
    private var connection = FirebaseConnection()
//    Publish user
//    Publish sessions
//    Publish tutor schedules
    
    let user_uid:String
    init(uid: String){
       user_uid = uid
    }
    
    
//    Create user
//    getRole
//    getSessions
//    createSession
//
}
