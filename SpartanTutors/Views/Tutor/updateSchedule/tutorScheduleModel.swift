//
//  tutorScheduleModel.swift
//  SpartanTutors
//
//  Created by Leo on 7/3/22.
//

import Foundation

struct TutorScheduleModel{
    var schedule: [String:Timeframe] = [:]
    
    init(){
        
    }
    
    //Gets a date in int format and timeframe as string
    init(new: [String:String]?){
        if let unwrapped = new{
            self.updateSchedule(new: unwrapped)
        }
    }
    
    mutating func updateSchedule(new: [String:String]){
        var new_dict:[String:Timeframe] = [:]
        for day_schedule in new.keys{
            new_dict[day_schedule] = Timeframe(new[day_schedule]!)
        }
        self.schedule = new_dict
    }
    
    mutating func update_time(ind:Int, date:String){
        self.schedule[date]!.update_time(ind: ind)
    }
    
    mutating func set_day(date:String){
        self.schedule[date] = Timeframe()
    }
    
    mutating func clear_schedule(date:String){
        schedule[date]!.clear_schedule()
    }
    
    mutating func full_schedule(date:String){
        schedule[date]!.full_schedule()
    }
}



