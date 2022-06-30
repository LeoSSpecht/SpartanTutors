//
//  CreateUserModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import Foundation
import FirebaseFirestore

class UserCreationModel:ObservableObject{
    @Published var name:String = ""
    @Published var major:String = ""
    @Published var phone:String = ""
    @Published var yearStatus:String = ""
    private var db = Firestore.firestore()
    
    func createUser(uid:String, first_sign_in:Bool = false){
        print("Trying to create user \(uid)")
        let user = user_first_time(
            id:uid,
            name: name,
            major: major,
            phone: phone,
            yearStatus: yearStatus,
            firstSignIn: first_sign_in)
        
        if self.name.contains("TuToR"){
            let tutor_info = Tutor(student_keys: user)
            createUser_tutor(userInfo: tutor_info)
        }
        else{
            createUser_student(userInfo: user)
        }
    }
    
    func createUser_student(userInfo: user_first_time){
        do {
            try db.collection("users").document(userInfo.id).setData(from: userInfo)
        } catch let error {
            print("Error writing session to Firestore: \(error)")
        }
    }
    
    func createUser_tutor(userInfo: Tutor){
        do {
            try db.collection("users").document(userInfo.id).setData(from: userInfo)
        } catch let error {
            print("Error writing session to Firestore: \(error)")
        }
    }
}

struct user_first_time: Codable, Identifiable, Hashable{
    var id: String = ""
    var name:String
    var major:String
    var phone:String
    var yearStatus:String
    var role = "student"
    var firstSignIn = false
    
    enum CodingKeys: String, CodingKey {
        case name
        case major
        case phone
        case yearStatus
        case role
        case firstSignIn
    }
}

struct Tutor:  Codable, Identifiable, Hashable{
    var id: String = ""
    var name:String
    var major:String
    var phone:String
    var yearStatus:String
    var role = "tutor"
    var firstSignIn = false
    
    var approved = false
    var classes:Array<String> = []
    var venmo = ""
    var TutorFirstSignIn = true
    
    init(student_keys: user_first_time){
        id = student_keys.id
        name = student_keys.name.replacingOccurrences(of: "TuToR", with: "")
        major = student_keys.major
        phone = student_keys.phone
        yearStatus = student_keys.yearStatus
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case major
        case phone
        case yearStatus
        case role
        case firstSignIn
        case approved
        case classes
        case venmo
        case TutorFirstSignIn
    }
}
