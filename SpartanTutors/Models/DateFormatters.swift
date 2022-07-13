//
//  DateFormatters.swift
//  SpartanTutors
//
//  Created by Leo on 7/11/22.
//

import Foundation


extension Date {
    func format(_ new_format: String) -> String{
        let df = DateFormatter()
        df.dateFormat = new_format
        let formatted = df.string(from: self)
        return formatted
    }
    
    func to_time() -> String{
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        let formatted = df.string(from: self)
        return formatted
    }

    func to_WeekDay_date() -> String{
        let df = DateFormatter()
        df.dateFormat = "eee - MM/dd/YY"
        let formatted = df.string(from: self)
        return formatted
    }

    func to_int_format() -> String{
        let df = DateFormatter()
        df.dateFormat = "YYYYMMd"
        let formatted = df.string(from: self)
        return formatted
    }
}
