//
//  updateScheduleViewModel.swift
//  SpartanTutors
//
//  Created by Leo on 7/3/22.
//

import Foundation
import FirebaseFirestore

class scheduleUpdateViewModel: ObservableObject{
    @Published var date = Date()
    @Published var showWorkedPopUp = false
    @Published var showInvalidPopUp = false
    @Published var showErrorPopUp = false
    @Published var model = TutorScheduleModel()
    
    private var id:String
    
    init(_ id:String){
        self.id = id
        getAllSchedules()
    }
    
    private var db = Firestore.firestore()
    
    var schedule: Array<Int>?{
        let day = dateToIntStr(date)
        check_if_date_exists()
        return model.schedule[day]
    }
    
    var hide_bar:Bool {
        self.showInvalidPopUp || self.showWorkedPopUp
    }
    func clear_schedule(){
        let day = dateToIntStr(date)
        model.clear_schedule(date: day)
    }
    func full_schedule(){
        let day = dateToIntStr(date)
        model.full_schedule(date: day)
    }
    
    func try_to_update_schedule(){
        if checkIfSelectedValid(){
            //Selection is valid, trying to update
            updateSchedule(){completed in
                if completed{
                    self.showWorkedPopUp = true
                    self.showErrorPopUp = false
                }
                else{
                    self.showErrorPopUp = true
                    self.showWorkedPopUp = false
                }
            }
        }
        else{
            //Date is not valid, show error pop up
            showInvalidPopUp = true
            showWorkedPopUp = false
        }
    }
    
    func check_if_date_exists(){
        let day = dateToIntStr(date)
        if model.schedule[day] == nil{
            //Date  doesn't exists
            model.set_day(date: day)
        }
    }
    
    func selectTime(ind:Int){
        let day = dateToIntStr(date)
        let current = model.schedule[day]![ind]
        if current == 1{
            //Change the index to 0
            model.update_time(ind: ind, date: day, new_value: 0)
        }
        else if current == 0{
            //Change the index to 1
            model.update_time(ind: ind, date: day, new_value: 1)
        }
        
    }
    
    func getAllSchedules(){
        db.collection("tutor_schedules").document(self.id).addSnapshotListener{result, err in
            if let result = result, result.exists{
                let data = result.data()!
                let tutor_schedules = data as! [String:String]
                self.model.updateSchedule(new: tutor_schedules)
            }
            else{
                print("No schedule exists yet")
            }
        }
    }
    
    func updateSchedule(_ completion: @escaping (_ err:Bool) -> Void){
        let day = self.dateToIntStr(self.date)
        //Converting the array of ints to Array of string
        let schedule_string = model.schedule[day]!.map{time in
            String(time)
        }
        db.collection("tutor_schedules").document(self.id).updateData(
            //Updates only the day the tutor has currently selected
            //If you want to update all the changes made do: model.schedule -> Remeber to make all of them strings
            [day:schedule_string.joined()]
        )
        {(err) in
            if let err = err {
                print("Error updating document: \(err)")
                completion(false)
            } else {
                print("Document successfully updated")
                completion(true)
            }
        }
    }
    
    func dateToIntStr(_ date: Date) -> String{
        return "\(Int((((date.timeIntervalSince1970/60)/60)/24)))"
    }
    
    func checkIfSelectedValid() -> Bool{
        let day = dateToIntStr(date)
        let schedule = model.schedule[day]!
        var counter = 0
        var isValid = true
        for ind in schedule.indices{
            let i = schedule[ind]
            if i == 1{
                counter += 1
            }
            else if i == 0{
                if counter < 4 && counter > 0{
                    isValid = false
                }
                else{
                    counter = 0
                }
            }
        }
        return isValid
    }
    
    
}
