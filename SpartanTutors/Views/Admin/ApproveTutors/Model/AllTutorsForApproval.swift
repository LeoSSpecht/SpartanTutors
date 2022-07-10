//
//  AllTutorsForApproval.swift
//  SpartanTutors
//
//  Created by Leo on 7/8/22.
//

import Foundation

struct TutorList{
    var tutors: Array<Tutor> = []
    
    //Repeated function from bookSessionViewModel
    mutating func update_tutors(_ new: Array<Tutor>){
        self.tutors = new
    }
    mutating func approve_tutor(ind:Int){
        tutors[ind].approved = true
    }
}
