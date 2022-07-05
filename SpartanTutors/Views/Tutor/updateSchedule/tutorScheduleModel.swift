//
//  tutorScheduleModel.swift
//  SpartanTutors
//
//  Created by Leo on 7/3/22.
//

import Foundation

struct TutorScheduleModel{
    var schedule: [String:Array<Int>] = [:]
    
    init(){
        
    }
    
    init(new: [String:String]?){
        if let unwrapped = new{
            self.updateSchedule(new: unwrapped)
        }
    }
    
    mutating func updateSchedule(new: [String:String]){
        var new_dict:[String:Array<Int>] = [:]
        for day_schedule in new.keys{
            new_dict[day_schedule] = []
            for i in new[day_schedule]!{
                let time_frame_value = Int(String(i))
                new_dict[day_schedule]?.append(time_frame_value!)
            }
        }
        self.schedule = new_dict
    }
    
    mutating func update_time(ind:Int, date:String,new_value:Int){
        self.schedule[date]![ind] = new_value
    }
    
    mutating func set_day(date:String){
        self.schedule[date] = Array(repeating: 0, count: 28)
    }
    
    mutating func clear_schedule(date:String){
        for i in schedule[date]!.indices{
            if schedule[date]![i] == 1{
                schedule[date]![i] = 0
            }
        }
    }
    
    mutating func full_schedule(date:String){
        for i in schedule[date]!.indices{
            if schedule[date]![i] == 0{
                schedule[date]![i] = 1
            }
        }
    }
}
