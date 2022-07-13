//
//  sessionModels.swift
//  SpartanTutors
//
//  Created by Leo on 6/21/22.
//

import Foundation

struct Session: Identifiable, Hashable{
    var id: String = ""
    var student_uid:String
    var tutor_uid:String
    var date: Date
    var time_slot_obj: Timeframe = Timeframe()
    var college_class: String
//        Possible: Pending, Approved, Canceled
    var status: String = "Pending"
    var paid: Bool = false
    var refunded: Bool = false
    var duration: Int = 2
    var paid_tutor: Bool = false
    var time_slot: String{
        time_slot_obj.to_string
    }
    
    init(_ content: [String: Any]){
        id = content["id"] as! String
        student_uid = content["student_uid"] as! String
        tutor_uid = content["tutor_uid"] as! String
        self.date = content["date"] as! Date
        time_slot_obj = Timeframe(content["time_slot"] as! String)
        college_class = content["college_class"] as! String
        if((content["status"]) != nil){
            status = content["status"] as! String
        }
        if((content["paid"]) != nil){
            paid = content["paid"] as! Bool
        }
        if((content["refunded"]) != nil){
            refunded = content["refunded"] as! Bool
        }
        if((content["duration"]) != nil){
            duration = content["duration"] as! Int
        }
    }
    
    func generate_dict() -> [String:Any]{
        return [
            "id": id,
            "student_uid":student_uid,
            "tutor_uid":tutor_uid,
            "date":date,
            "college_class":college_class,
            "status":status,
            "paid":paid,
            "refunded":refunded,
            "duration":duration,
            "paid_tutor":paid_tutor,
            "time_slot":time_slot
        ]
    }
    
    func get_time_frame() -> String {
        if let ind = self.time_slot_obj.data.firstIndex(where: {$0 == 2}){
            var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.date)
            components.hour = Timeframe.ind_to_hour(ind: ind)
            components.minute = Timeframe.ind_to_min(ind: ind)
            let start_time = Calendar.current.date(from: components)
            components.hour = Timeframe.ind_to_hour(ind: ind) + duration
            let end_time = Calendar.current.date(from: components)
            return "\(start_time!.to_time()) - \(end_time!.to_time())"
        }
        return ""
    }
}

