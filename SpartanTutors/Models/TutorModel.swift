//
//  TutorModel.swift
//  SpartanTutors
//
//  Created by Leo on 7/8/22.
//

import Foundation
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
    var zoom_link = ""
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
        case zoom_link
        case TutorFirstSignIn
    }
}
//
//struct TutorSummary{
//    var id:String
//    var name:String
//    var zoom_link:String
//}

