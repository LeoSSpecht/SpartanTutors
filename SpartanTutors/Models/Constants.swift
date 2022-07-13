//
//  Constants.swift
//  SpartanTutors
//
//  Created by Leo on 7/11/22.
//
import Foundation
import SwiftUI
struct TimeConstants{
    static let time_interval = 15
    static let units_in_session = 60*2/time_interval
    static let times_in_hour = 60/time_interval
    static let times_in_day:Int = (DayConstants.ending_time-DayConstants.starting_time)*(60/time_interval)
}

struct DayConstants{
    static let starting_time = 8
    static let ending_time = 22
}

struct FontConstants{
    static var calendar_day_scale:CGFloat = 1.6
}
