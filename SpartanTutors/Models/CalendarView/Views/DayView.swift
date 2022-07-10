//
//  DayView.swift
//  AnimationTest
//
//  Created by Leo on 7/9/22.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var calendarViewModel: calendarVM
    @Binding var selected_date: Date
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    let days = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
    ]
    
    var body: some View {
        VStack{
            Text(calendarViewModel.month_selected)
                .fontWeight(.bold)
            HStack(alignment: .top){
                Image(systemName: "chevron.left")
                    .padding(.leading)
                    .imageScale(.small)
                    .onTapGesture {
                        calendarViewModel.change_week(to: -1)
                    }
                Spacer()
                LazyVGrid(columns:columns){
                    ForEach(
                        (calendarViewModel.ind_begin...calendarViewModel.ind_end),
                        id: \.self)
                    { i in
                        VStack{
                            Text("\(days[i%7])")
                                .foregroundColor(.gray)
                                .scaledToFill()
                            let day = calendarViewModel.model.days_list[i]
                            dayView(day: day.day_number,
                                    isValid: day.isValid,
                                    isSelected: day.isSelected)
                                .onTapGesture{
                                    calendarViewModel.choose(day.index)
                                    selected_date = day.date
                                }
                        }
                    }
                }.padding([.leading, .bottom, .trailing])
                .layoutPriority(1)
                Spacer()
                Image(systemName: "chevron.right")
                    .imageScale(.small)
                    .padding(.trailing)
                    .onTapGesture {
                        calendarViewModel.change_week(to: 1)
                    }
                
            }
        }
        
    }
}

struct dayView: View{
    var day: String
    var isValid: Bool
    var isSelected: Bool
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? .blue : Color.white, lineWidth: 2)
            Text(day)
                .font(.title3)
                .foregroundColor(isValid ? .black : .gray)
                .fontWeight(isSelected ? .bold : .regular)
        }.aspectRatio(1,contentMode: .fit)
    }
}
//
//struct DayView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
