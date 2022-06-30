//
//  sessionModels.swift
//  SpartanTutors
//
//  Created by Leo on 6/21/22.
//

import Foundation

struct Session: Codable, Identifiable, Hashable{
    var id: String = ""
    var student_uid:String
    var tutor_uid:String
    var date: Date
    var time_slot: String
    var college_class: String
//        Possible: Pending, Approved, Canceled
    var status: String = "Pending"
    var paid: Bool = false
    var refunded: Bool = false
    var duration: Int = 2
    
    init(_ content: [String: Any]){
        id = content["id"] as! String
        student_uid = content["student_uid"] as! String
        tutor_uid = content["tutor_uid"] as! String
        self.date = content["date"] as! Date
        time_slot = content["time_slot"] as! String
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
    
    enum CodingKeys: String, CodingKey {
        case student_uid
        case tutor_uid
        case date
        case time_slot
        case status
        case paid
        case refunded
        case college_class
        case id
        case duration
    }
    
    func get_time_frame() -> String {
        let inital_time = 8
        var ind:Int = 0
        for i in self.time_slot{
            if i == "2"{
                break
            }
            ind += 1
        }
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.date)
        components.hour = inital_time+ind/2
        components.minute = ind%2 == 0 ? 0 : 30
        let start_time = Calendar.current.date(from: components)
        components.hour = inital_time+ind/2 + duration
        let end_time = Calendar.current.date(from: components)
        return "\(date_to_time(date: start_time!)) - \(date_to_time(date: end_time!))"
    }
    
    func date_to_time(date: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        let formatted = df.string(from: date)
        return formatted
    }
    
    func date_to_string() -> String{
        let df = DateFormatter()
        df.dateFormat = "eee MM/dd/YYYY"
        let formatted = df.string(from: self.date)
        return formatted
    }
    
    
}

