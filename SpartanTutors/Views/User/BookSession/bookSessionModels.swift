//
//  bookSessionModels.swift
//  SpartanTutors
//
//  Created by Leo on 6/23/22.
//

import Foundation

struct sessionBookerData{
    let initial_time = DayConstants.starting_time
    private (set) var all_tutors: Array<TutorSummary> = []
    private (set) var tutors_for_class:Array<TutorSummary> = []
    private (set) var id_schedule_dict = [String:TutorSchedule]()
    //Class name -> Array of tutor ids
    private (set) var classes_dict = [String:Array<String>]()
    private (set) var available_times:Array<sessionTime> = []
    
//    MARK: UPDATING FUNCTIONS
//    mutating func update_tutors(new_tutors:Array<TutorSummary>){
//        self.all_tutors = new_tutors
//    }
    //NEW
    mutating func update_id_schedule(new: [String:TutorSchedule], classes_available: [String:Array<String>]){
        id_schedule_dict = new
        classes_dict = classes_available
    }
    
    var all_classes: Array<String>{
        Array(classes_dict.keys).sorted()
    }
    
    mutating func update_tutor_schedule(new_schedule: [String:Any], id: String){
        id_schedule_dict[id]!.update_schedule(new_schedule)
    }
    
    
    //END NEW
    mutating func create_available_times(tutor:String = "Any", date: Date = Date(), college_class:String){
        print("Started updating available times")
        available_times = build_final_time_list(tutor: tutor, date: date, college_class: college_class)
        print("Finished updating times")
    }
    
    mutating func choose_session(_ id: Int) -> sessionTime?{
        if let index = available_times.firstIndex(where: {$0.id == id}){
            for i in available_times.indices{
                self.available_times[i].selected = false
            }
            self.available_times[index].selected = true
            return self.available_times[index]
        }
        return nil
    }
    
    func get_tutor_name(id: String) -> String{
        return id_schedule_dict[id]!.tutorName
    }
    
    private func build_available_times(time_frame: Timeframe, duration:Int ,date:Date,string_date: String,tutor_id:String, tutor_name: String) ->[Int:sessionTime]{
//      Description: Decodes from bitstring date format to string time and returns available bitstrings
        var all_available_times:[Int:sessionTime] = [:]
//        Times from 8-22 from 15-15 min
        for i in 0..<(TimeConstants.times_in_day-duration*TimeConstants.times_in_hour+1){
            let nextSessionTime = Array(time_frame.data[i..<i+duration*TimeConstants.times_in_hour])
            if nextSessionTime == Array(repeating: 1, count: duration*TimeConstants.times_in_hour){
//              If time is already not taken
                let timeframe = String(repeating: "0", count: i)+String(repeating: "2", count: duration*TimeConstants.times_in_hour)+String(repeating: "0", count: TimeConstants.times_in_day-i-duration*TimeConstants.times_in_hour)
                let formatted_date = time_frame_to_date(time_slot: Timeframe(timeframe), date: date)
                
                // Checks if time is greater than now
                if formatted_date > Date(){
                    all_available_times[i] = sessionTime(sessionDate: formatted_date, string_date: string_date, tutor: tutor_id, tutor_name: tutor_name, timeframe: Timeframe(timeframe), id: i)
                }
            }
        }
        return all_available_times
    }

    private func return_sorted_schedule(schedule: [Int : sessionTime]) -> Array<sessionTime>{
        return Array(schedule.values).sorted{
            return $0.sessionDate < $1.sessionDate
        }
    }
    
    private func build_final_time_list(tutor:String, date:Date,college_class:String) -> Array<sessionTime>{
        let date_convert:String = date.to_int_format()
        print(date_convert)
        if tutor != "Any"{
            //Get times available for specific tutor
            let tutor_name = self.get_tutor_name(id: tutor)
            if let timeframe = self.id_schedule_dict[tutor]!.schedule[date_convert]{
                //DICT index -> Session time with times for specifict tutors
                let availableTimes = build_available_times(time_frame: timeframe, duration: 2, date: date, string_date: date_convert, tutor_id: tutor, tutor_name: tutor_name)
                return return_sorted_schedule(schedule: availableTimes)
            }
            
            return []
        }
        else{
            //Get times for all tutors
            if let tutorsID_for_class = classes_dict[college_class]{
                //Gets all tutors for that day
                var all_tutors_schedule:[TutorSchedule] = []
                tutorsID_for_class.forEach{tutor in
                    if self.id_schedule_dict[tutor]!.schedule[date_convert] != nil{
                        //If the tutor has a schedule for that day
                        all_tutors_schedule.append(TutorSchedule(old: self.id_schedule_dict[tutor]!, specific_date: date_convert))
                    }
                }
                
                //Creating schedule for all tutors
                var final_random_tutor_schedule = [Int:sessionTime]()
                all_tutors_schedule.forEach{ tutor_schedule in
                    let tutor_name = self.get_tutor_name(id: tutor_schedule.id)
                    let availableTimes = build_available_times(
                        time_frame: tutor_schedule.schedule[date_convert]!,
                        duration: 2,
                        date: date,
                        string_date: date_convert,
                        tutor_id: tutor_schedule.id,
                        tutor_name: tutor_name)
                    availableTimes.forEach{time in
                        if final_random_tutor_schedule[time.key] == nil{
                            final_random_tutor_schedule[time.key] = time.value
                        }
                    }
                }
                return return_sorted_schedule(schedule: final_random_tutor_schedule)
            }
            return []
        }
    }
    
    func time_frame_to_date(time_slot:Timeframe, date:Date) -> Date {
        let ind = time_slot.get_first_session_index()!
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        components.hour = Timeframe.ind_to_hour(ind: ind)
        components.minute = Timeframe.ind_to_min(ind: ind)
        let start_time = Calendar.current.date(from: components)
        return start_time!
    }
}

struct TutorSchedule: Codable, Identifiable, Hashable {
//    Tutor ID
    var id:String = ""
//    Date:Time bitstring
    var schedule: [String:Timeframe] = [:]
//    Classes available
    var classes: Array<String> = []
    var tutorName:String
    
    var schedule_to_string: [String:String]{
        var new_dict = [String:String]()
        for key in schedule.keys{
            new_dict[key] = schedule[key]!.to_string
        }
        return new_dict
    }
    
    init(id:String, available_classes: Array<String>, name: String){
        self.id = id
        self.classes = available_classes
        self.tutorName = name
    }
    
    init(old: TutorSchedule, specific_date: String){
        self.id = old.id
        self.classes = old.classes
        self.schedule[specific_date] = old.schedule[specific_date]!
        self.tutorName = old.tutorName
        
    }
    
    mutating func update_schedule(_ content: [String:Any]){
        for key in content.keys{
            schedule[key] = Timeframe(content[key]! as! String)
        }
    }
}

struct sessionTime: Hashable, Identifiable{
    //Date in the right format
    var sessionDate:Date
    //Date in the int-string format
    var string_date:String
    //Tutor id
    var tutor:String
    var tutor_name:String
    //bitstring
    var timeframe:Timeframe
    var id: Int
    var selected = false
    
    var time_string: String{
        sessionDate.to_time()
    }
}
