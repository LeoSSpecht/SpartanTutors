//
//  bookSessionModels.swift
//  SpartanTutors
//
//  Created by Leo on 6/23/22.
//

import Foundation

struct sessionBookerData{
    let initial_time = 8
    private (set) var all_tutors: Array<TutorSummary> = []
    private (set) var tutors_for_class:Array<TutorSummary> = []
    private (set) var id_schedule_dict = [String:TutorSchedule]()
    //Class name -> Array of tutor ids
    private (set) var classes_dict = [String:Array<String>]()
    private (set) var available_times:Array<sessionTime> = []
    
//    MARK: UPDATING FUNCTIONS
    mutating func update_tutors(new_tutors:Array<TutorSummary>){
        self.all_tutors = new_tutors
    }
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
        print(available_times)
    }
    
    mutating func choose_session(_ ind: Int){
        for i in available_times.indices{
            self.available_times[i].selected = false
        }
        self.available_times[ind].selected = true
    }
    
    private func build_available_times(time_frame:String, duration:Int ,date:Date,string_date: String,tutor_id:String) ->[Int:sessionTime]{
//      Description: Decodes from bitstring date format to string time and returns available bitstrings
        var all_available_times:[Int:sessionTime] = [:]
        let str = time_frame
//        Times from 8-22 from 30-30 min
        for i in 0..<(28-duration*2+1){
            let start = str.index(str.startIndex, offsetBy: i)
            let end = str.index(str.startIndex, offsetBy: i+duration*2)
            let range = start..<end
            let mySubstring = String(str[range]) // play
            if mySubstring == String(repeating: "1", count: duration*2){
//              If time is already not taken
                let timeframe = String(repeating: "0", count: i)+String(repeating: "2", count: duration*2)+String(repeating: "0", count: 28-i-duration*2)
                let formatted_date = time_frame_to_date(time_slot:timeframe, date: date, duration: duration)
                all_available_times[i] = sessionTime(sessionDate: formatted_date, string_date: string_date, tutor: tutor_id, timeframe: timeframe, id: i)
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
        let date_convert:String = String(Int((((date.timeIntervalSince1970/60)/60)/24)))
        if tutor != "Any"{
            //Get times available for specific tutor
            if let timeframe = self.id_schedule_dict[tutor]!.schedule[date_convert]{
                //DICT index -> Session time with times for specifict tutors
                let availableTimes = build_available_times(time_frame: timeframe, duration: 2, date: date, string_date: date_convert, tutor_id: tutor)
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
                    let availableTimes = build_available_times(
                        time_frame: tutor_schedule.schedule[date_convert]!,
                        duration: 2,
                        date: date,
                        string_date: date_convert,
                        tutor_id: tutor_schedule.id)
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
    
    //REPEATED FUNCTION
    func time_frame_to_date(time_slot:String, date:Date, initial_time:Int = 8, duration:Int = 2) -> Date {
        var ind:Int = 0
        for i in time_slot{
            if i == "2"{
                break
            }
            ind += 1
        }
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        components.hour = initial_time+ind/2
        components.minute = ind%2 == 0 ? 0 : 30
        let start_time = Calendar.current.date(from: components)
        return start_time!
    }
}

struct TutorSchedule: Codable, Identifiable, Hashable {
//    Tutor ID
    var id:String = ""
//    Date:Time bitstring
    var schedule: [String:String] = [:]
//    Classes available
    var classes: Array<String> = []
    var tutorName:String
    
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
        schedule = Dictionary(uniqueKeysWithValues:
                    content.map{key, value in
                        (String(key),value as! String )
                    }
                )
    }
    
    enum CodingKeys: String, CodingKey {
        case schedule
        case classes
        case tutorName
    }
    
}

struct sessionTime: Equatable, Hashable, Identifiable{
    //Date in the right format
    var sessionDate:Date
    //Date in the int-string format
    var string_date:String
    //Tutor id
    var tutor:String
    //bitstring
    var timeframe:String
    var id: Int
    var selected = false
    
    static func == (lhs: sessionTime, rhs: sessionTime) -> Bool {
            return lhs.string_date == rhs.string_date && lhs.timeframe == rhs.timeframe
        }
    
    var time_string: String{
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        let formatted = df.string(from: sessionDate)
        return formatted
    }
}
