//
//  CalendarModel.swift
//  AnimationTest
//
//  Created by Leo on 7/9/22.
//

import Foundation

struct calendarModel{
    var today:Date
    var days_list:[dayModel] = []
    var index_of_selection = 0
    
    init(){
        today = Date()
        let day_of_week = Calendar.current.component(.weekday, from: self.today) // 1 Sun -> 7 Sat
        var start = Calendar.current.date(byAdding: .day, value: -day_of_week+1, to: today)!
        let end = Calendar.current.date(byAdding: .month, value: 1, to: today)!
        var count = 0
        while start < end{
            var isValid = true
            var isSelected = false
            if start < today{
                isValid = false
            }
            if start == today{
                isSelected = true
                index_of_selection = count
            }
            days_list.append(dayModel(date: start, isValid: isValid, index: count, isSelected: isSelected))
            start = Calendar.current.date(byAdding: .day, value: 1, to: start)!
            count += 1
        }
    }
    
    mutating func choose(_ ind:Int){
        if ind != index_of_selection
            && days_list[ind].isValid
        {
            days_list[index_of_selection].isSelected = false
            days_list[ind].isSelected = true
            index_of_selection = ind
        }
    }
}

struct dayModel{
    var date: Date
    var isValid: Bool
    var index: Int
    var isSelected = false
    
    var day_number: String{
        let df = DateFormatter()
        df.dateFormat = "d"
        return df.string(from: date)
    }
}
