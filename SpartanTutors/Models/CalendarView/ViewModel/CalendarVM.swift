//
//  CalendarVM.swift
//  AnimationTest
//
//  Created by Leo on 7/9/22.
//

import Foundation

class calendarVM: ObservableObject{
    @Published var model = calendarModel()
    @Published var startingIndex = 0
    
    var week_index: Int{
        startingIndex*7
    }
    
    var month_selected:String{
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        let start_month = df.string(from: model.days_list[ind_begin].date)
        let end_month = df.string(from: model.days_list[ind_end].date)
        if start_month == end_month{
            return start_month
        }
        else{
            return "\(start_month) - \(end_month)"
        }
    }
    
    var ind_begin: Int{
        self.week_index
    }
    
    var ind_end: Int{
        let ind_max = self.model.days_list.count-1
        return ind_begin+6 < ind_max ? ind_begin+6 : ind_max
    }
    
    func choose(_ ind: Int){
        model.choose(ind)
    }
    
    func change_week(to: Int){
        if to < 0{
            if startingIndex > 0{
                startingIndex -= 1
            }
        }
        else{
            let maxIndex = model.days_list.count/7
            if startingIndex < maxIndex{
                startingIndex += 1
            }
        }
    }
}
