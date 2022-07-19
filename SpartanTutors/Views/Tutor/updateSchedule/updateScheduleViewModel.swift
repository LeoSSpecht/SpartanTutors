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
    
    private var listeners: [ListenerRegistration] = []
    private var id:String
    
    init(_ id:String){
        self.id = id
        getAllSchedules()
    }
    
    deinit{
        for i in listeners.indices{
            listeners[i].remove()
        }
    }
    private var db = Firestore.firestore()
    
    var schedule: Timeframe?{
        let day = date.to_int_format()
        check_if_date_exists()
        return model.schedule[day]
    }
    
    var hide_bar:Bool {
        self.showInvalidPopUp || self.showWorkedPopUp
    }
    func clear_schedule(){
        let day = date.to_int_format()
        model.clear_schedule(date: day)
    }
    func full_schedule(){
        let day = date.to_int_format()
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
        let day = date.to_int_format()
        if model.schedule[day] == nil{
            //Date  doesn't exists
            model.set_day(date: day)
        }
    }
    
    func selectTime(ind:Int){
        let day = date.to_int_format()
        model.update_time(ind: ind, date: day)
    }
    
    func getAllSchedules(){
        let listen = db.collection("tutor_schedules").document(self.id).addSnapshotListener{result, err in
            if let result = result, result.exists{
                let data = result.data()!
                let tutor_schedules = data as! [String:String]
                self.model.updateSchedule(new: tutor_schedules)
            }
            else{
                print("No schedule exists yet")
            }
        }
        listeners.append(listen)
    }
    
    func updateSchedule(_ completion: @escaping (_ err:Bool) -> Void){
        //VERY CAREFUL WITH THIS CORRECTING TIME ZONE STUFF FOR POSSIBLE CONFUSIONS - WORKAROUND!!!!!
//        let corrected_time_zone_date = correct_time_zone(date: self.date)
//        print(corrected_time_zone_date)
        let day = self.date.to_int_format()
        print(day)
        let schedule_string = model.schedule[day]!.to_string
        db.collection("tutor_schedules").document(self.id).setData(
            //Updates only the day the tutor has currently selected
            //If you want to update all the changes made do: model.schedule -> Remeber to make all of them strings
            [day:schedule_string], merge: true
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
    
    func checkIfSelectedValid() -> Bool{
        let day = date.to_int_format()
        return model.schedule[day]!.is_valid_to_update()
    }
}
