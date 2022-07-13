//
//  tutorClassesModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/26/22.
//

import Foundation

struct TutorSummary: Codable, Hashable {
    var id:String
    var name:String
    var zoom_link:String  = ""
}
