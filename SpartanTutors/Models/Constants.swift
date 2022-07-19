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

struct SmallButtonLegend: ButtonStyle {
    var color_main = Color(red: 0.6, green: 0.6, blue: 0.6)
    var color_pressed = Color(red: 0.5, green: 0.5, blue: 0.5)
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .padding(5)
            .background(configuration.isPressed ? color_pressed : color_main)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}
