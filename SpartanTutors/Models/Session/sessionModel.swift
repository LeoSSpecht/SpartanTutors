//
//  sessionModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import Foundation


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class sessionScheduler: ObservableObject{
    private var db = Firestore.firestore()
    @Published private (set) var studentSessions: Array<Session> = []
    @Published private (set) var tutor_schedules:Array<TutorSchedule> = []
    @Published private (set) var avaialable_times:Array<Array<String>> = []
    
    private var student_id:String
    init(uid: String){
        student_id = uid
        retrieveStudentSessions()
        getTutorSchedules()
        
    }
    
    func getTutorSchedules(){
        let ref = db.collection("tutor_schedules")
        ref.getDocuments(){ (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.tutor_schedules = documents.map { (queryDocumentSnapshot) -> TutorSchedule in
                    let dict = queryDocumentSnapshot.data()
                    return TutorSchedule(dict,id_i: queryDocumentSnapshot.documentID)
                }
            self.build_final_time_list(tutor: "Any", date: Date(), college_class: "CSE 102")
            }
    }
    func bookSession(_ session: Session) -> Bool{
//        Books session
        var final_session = session
        let ref = db.collection("Sessions")
        let docId = ref.document().documentID
        
        do {
            final_session.id = docId
            try db.collection("Sessions").document(docId).setData(from: final_session)
            return true
        } catch let error {
            print("Error writing session to Firestore: \(error)")
            return false
        }
        
//        Changes tutor schedule
    }
    
    func retrieveStudentSessions(){
        let ref = db.collection("Sessions")
        self.studentSessions.removeAll()
        ref.whereField("student_uid", isEqualTo: student_id)
            .addSnapshotListener() { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.studentSessions = documents.map { (queryDocumentSnapshot) -> Session in
                    var dict = queryDocumentSnapshot.data()
                    dict["id"] = queryDocumentSnapshot.documentID
                    let stamp: Timestamp = dict["date"] as! Timestamp
                    dict["date"] = stamp.dateValue()
                    return Session(dict)
                }
            }
        }
    
    func changeSessionStatus(session_id: String, session_status: String) -> Bool{
        var newStatus: [String:Any] = [
            "status": session_status
        ]
        switch session_status {
            case "Approved":
                newStatus["paid"] = true
            case "Canceled":
                newStatus["refunded"] = true
            default:
                print("do nothing")
        }
        let ref = db.collection("Sessions")
        var result = false
        ref.document(session_id).updateData(newStatus) { (err) in
            if let err = err {
                print("Error updating document: \(err)")
                result = false
            } else {
                print("Document successfully updated")
                result = true
            }
        }
        return result
    }
    
    func createSessionObject(content: [String:Any]){
        var content = content
        content["student_uid"] = student_id
        let sessionToBook = Session(content)
        if bookSession(sessionToBook){
            retrieveStudentSessions()
        }
    }
    
    func get_tutors_for_day(_ all_schedules: Array<TutorSchedule>,tutor_id:String = "Any", date:Int) -> Array<TutorSchedule>{
        var schedules = all_schedules
        if tutor_id != "Any"{
            schedules = all_schedules.filter{ tutor_schedule in
                return tutor_schedule.id == tutor_id
            }
        }
        
        var schedules_for_date:[TutorSchedule] = []
        for all_days in schedules{
            if all_days.schedule[date] != nil{
                schedules_for_date.append(TutorSchedule(["\(date)":all_days.schedule[date]!],id_i:all_days.id))
            }
        }
        return schedules_for_date
    }
    
    func build_available_times(schedules_for_date:Array<TutorSchedule>, hours:Int,date:Int) -> [Int:String]{
//        StartTime:TutorId
        var all_available_times:[Int:String] = [:]
        
//        Times from 8-22 from 30-30 min
        for schedule in schedules_for_date{
            
            for i in 0..<(28-hours*2){
                let str = schedule.schedule[date]!
                let start = str.index(str.startIndex, offsetBy: i)
                let end = str.index(str.startIndex, offsetBy: i+hours*2)
                let range = start..<end
                let mySubstring = String(str[range]) // play
                if mySubstring == String(repeating: "1", count: hours*2){
                    print((schedule.id))
//                    If time is already not taken
                    if all_available_times[i] == nil{
                        all_available_times[i] = schedule.id
                    }
                }
            }
        }
        return all_available_times
    }
    
    func build_string_times(all_available_times:[Int:String]) -> Array<Array<String>>{
        let inital_time = 8
        var available_string_times:Array<Array<String>> = []
        for time in all_available_times{
            if time.key % 2 == 0{
//                Whole hour
                available_string_times.append(["\(time.key/2+inital_time):00",time.value])
            }
            else{
//                Half-time hour
                available_string_times.append(["\(time.key/2+inital_time):30",time.value])
            }
        }
        
        return available_string_times
    }
    
    func build_final_time_list(tutor:String, date:Date,college_class:String){
        let all_schedules = self.tutor_schedules
        let date_convert:Int = Int((((date.timeIntervalSince1970/60)/60)/24))
        let r1 = get_tutors_for_day(all_schedules,tutor_id: tutor, date: date_convert)
//        print("R1 \(r1)")
        let r2 = build_available_times(schedules_for_date: r1, hours: 2, date: date_convert)
        print("R2 \(r2)")
        self.avaialable_times = build_string_times(all_available_times: r2)
    }
}
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
    
    init(_ content: [String: Any]){
        id = content["id"] as! String
        student_uid = content["student_uid"] as! String
        tutor_uid = content["tutor_uid"] as! String
        date = content["date"] as! Date
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
    }
}

struct TutorSchedule: Codable, Identifiable, Hashable {
    var id:String = ""
    var schedule: [Int:String]
    
    init(_ content: [String:Any], id_i:String){
        id = id_i
        schedule = Dictionary(uniqueKeysWithValues:
            content.map{key, value in
                (Int(key)!,value as! String )
            }
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case schedule
    }
    
}
