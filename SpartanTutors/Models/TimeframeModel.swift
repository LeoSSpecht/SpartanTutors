//
//  TimeframeModel.swift
//  SpartanTutors
//
//  Created by Leo on 7/11/22.
//

import Foundation

struct Timeframe: Codable, Hashable{
    var data = Array(repeating: 0, count: TimeConstants.times_in_day)
//    var time_zone = TimeZone.current.secon
    
    var to_string:String{
        self.data.map{
            String($0)
        }.joined()
    }
    
    init(){
        
    }
    
    init(_ new_data:String){
        self.update_from_string(new_data)
    }
    
    init(_ new_data:Array<Int>){
        self.data = new_data
    }
    
    mutating func update_from_string(_ new_time: String){
        self.data.removeAll()
        for i in new_time{
            let time_frame_value = Int(String(i))
            self.data.append(time_frame_value!)
        }
    }
    
    mutating func update_whole_day(_ new_data:Array<Int>){
        self.data = new_data
    }
    
    mutating func update_time(ind:Int){
        if self.data[ind] == 1{
            self.data[ind] = 0
        }
        else if self.data[ind] == 0{
            self.data[ind] = 1
        }
    }
    
    mutating func cancel_session_time(ind:Int){
        self.data[ind] = 1
    }
    
    mutating func clear_schedule(){
        for i in self.data.indices{
            if self.data[i] == 1{
                self.data[i] = 0
            }
        }
    }
    
    mutating func full_schedule(){
        for i in self.data.indices{
            if self.data[i] == 0{
                self.data[i] = 1
            }
        }
    }
    
    mutating func update_time_for_new_session(session_time: Timeframe) -> Bool{
        for i in session_time.data.indices{
            if session_time.data[i] == 2{
                if self.data[i] != 1{
                    return false
                }
                else if self.data[i] == 1{
                    self.data[i] = 2
                }
            }
        }
        return true
    }

    static func ind_to_min(ind:Int) -> Int{
        if ind % 4 == 0{
            return 0
        }
        else if ind % 2 == 1{
            if ind % 4 == 1{
                return 15
            }
            else{
                return 45
            }
        }
        return 30
    }
    
    static func ind_to_hour(ind: Int) -> Int{
        let inital_time = DayConstants.starting_time
        return inital_time+ind/4
    }
    
    static func get_time_from_frame(ind: Int) -> String{
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        components.hour = ind_to_hour(ind: ind)
        components.minute = ind_to_min(ind: ind)
        let start_time = Calendar.current.date(from: components)
        return "\(start_time!.to_time())"
    }
    
    func is_valid_to_update() -> Bool{
        var counter = 0
        var isValid = true
        for i in self.data{
            if i == 1{
                counter += 1
            }
            else if i == 0{
                if counter < TimeConstants.units_in_session && counter > 0{
                    isValid = false
                }
                else{
                    counter = 0
                }
            }
        }
        return isValid
    }
    
    func get_first_session_index() -> Int?{
        return self.data.firstIndex(where: {$0 == 2})
    }
}
