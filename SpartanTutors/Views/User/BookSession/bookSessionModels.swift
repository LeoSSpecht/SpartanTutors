//
//  bookSessionModels.swift
//  SpartanTutors
//
//  Created by Leo on 6/23/22.
//

import Foundation

struct sessionBookerData{
    let initial_time = 8
    private (set) var available_times:Array<Array<String>> = []
    private (set) var tutor_schedules:Array<TutorSchedule> = []
    private (set) var all_classes: Set<String> = []
    private (set) var all_tutors: Array<TutorClass> = []
    private (set) var tutors_for_class:Array<TutorClass> = []
    
//    MARK: UPDATING FUNCTIONS
    mutating func update_classes(new_classes:Set<String>){
        self.all_classes = new_classes
    }
    
    mutating func update_tutors(new_tutors:Array<TutorClass>){
        self.all_tutors = new_tutors
    }
    
    mutating func update_tutor_times(new_times: Array<TutorSchedule>){
        tutor_schedules = new_times
    }
    
    mutating func update_tutors_for_class(class_selection:String){
        tutors_for_class = all_tutors.filter{ tutor in
            tutor.classes.contains(class_selection)
        }
    }
    mutating func update_available_times(tutor:String = "Any", date: Date = Date(), college_class:String){
        print("Started updating available times")
        available_times = build_final_time_list(tutor: tutor, date: date, college_class: college_class)
        print("Finished updating times")
    }
    
    
    //UPDATE TIMES
    private func get_tutors_for_day(_ all_schedules: Array<TutorSchedule>,tutor_id:String = "Any", date:String,college_class:String) -> Array<TutorSchedule>{
//      Description: Gets all of the tutors for a specific day
        var schedules = all_schedules
//        Filter for tutor
        if tutor_id != "Any"{
            schedules = all_schedules.filter{ tutor_schedule in
                return tutor_schedule.id == tutor_id
            }
        }
//        Filter for class
        schedules = schedules.filter{ tutor_schedule in
//            Gets classes that the specific tutor is available for
            let classes_availabe = all_tutors.first(where: {tutor in tutor.id == tutor_schedule.id})?.classes ?? []
            return classes_availabe.contains(college_class)
        }

        var schedules_for_date:[TutorSchedule] = []
//        Gets all tutors for that specific date
        for all_days in schedules{
//            Check if tutor is available for that day
            if all_days.schedule[date] != nil{
                schedules_for_date.append(TutorSchedule(["\(date)":all_days.schedule[date]!],id_i:all_days.id))
            }
        }
        return schedules_for_date
    }
    
    private func build_available_times(schedules_for_date:Array<TutorSchedule>, hours:Int,date:String) ->[Int:sessionTime]{
//      Description: Decodes from bitstring date format to string time and returns available bitstrings
        
        var all_available_times:[Int:sessionTime] = [:]
//        Times from 8-22 from 30-30 min
        for schedule in schedules_for_date{
            for i in 0..<(28-hours*2+1){
                let str = schedule.schedule[date]!
                let start = str.index(str.startIndex, offsetBy: i)
                let end = str.index(str.startIndex, offsetBy: i+hours*2)
                let range = start..<end
                let mySubstring = String(str[range]) // play
                if mySubstring == String(repeating: "1", count: hours*2){
//                    If time is already not taken
                    if all_available_times[i] == nil{
                        let timeframe = String(repeating: "0", count: i)+String(repeating: "2", count: hours*2)+String(repeating: "0", count: 28-i-hours*2)
                        all_available_times[i] = sessionTime(time: String(i), tutor: schedule.id, timeframe: timeframe)
                    }
                }
            }
        }
        return all_available_times
    }
    
    private func build_string_times(all_available_times:[Int:sessionTime]) -> Array<Array<String>>{
//      Description: Gets available bitstrings and converts to hh:mm time
        let inital_time = self.initial_time
        var available_string_times:Array<Array<String>> = []
        for time in all_available_times{
            if time.key % 2 == 0{
//                Whole hour
                available_string_times.append(["\(time.key/2+inital_time):00",time.value.tutor,time.value.timeframe])
            }
            else{
//                Half-time hour
                available_string_times.append(["\(time.key/2+inital_time):30",time.value.tutor,time.value.timeframe])
            }
        }
        
        return available_string_times
    }
    
    private func build_final_time_list(tutor:String, date:Date,college_class:String) -> Array<Array<String>>{
        let all_schedules = self.tutor_schedules
        let date_convert:String = String(Int((((date.timeIntervalSince1970/60)/60)/24)))
        let r1 = get_tutors_for_day(all_schedules,tutor_id: tutor, date: date_convert,college_class: college_class)
        let r2 = build_available_times(schedules_for_date: r1, hours: 2, date: date_convert)
        return build_string_times(all_available_times: r2)
    }
}

struct TutorSchedule: Codable, Identifiable, Hashable {
//    Tutor ID
    var id:String = ""
//    Date:Time bitstring
    var schedule: [String:String]
    
    init(_ content: [String:Any], id_i:String){
        id = id_i
        schedule = Dictionary(uniqueKeysWithValues:
            content.map{key, value in
                (String(key),value as! String )
            }
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case schedule
    }
    
}

struct sessionTime{
//    String format time
    var time:String
//    Tutor id
    var tutor:String
//    bitstring
    var timeframe:String
}
