//
//  bookSessionView.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct bookSessionView: View {
    @ObservedObject var sessionViewModel: sessionScheduler
    @State private var classSelection = "CSE 102"
    @State private var tutorSelection = "Any"
    @State private var dateSelection:Date = Date()
    @State private var sessionSelections:String = ""
    let classes = ["CSE 102", "CSE 231", "CSE 232"]
    let tutors = ["Leo","Chris"]
//    availableTimes = sessionViewModel.build_final_time_list(tutor: tutorSelection, date: dateSelection, college_class: classSelection)
    init(VM: sessionScheduler){
        sessionViewModel = VM
        sessionViewModel.getTutorSchedules()
    }
    
    private var dateProxy:Binding<Date> {
        Binding<Date>(get: {self.dateSelection }, set: {
            self.dateSelection = $0
            sessionViewModel.build_final_time_list(tutor: tutorSelection, date: dateSelection, college_class: classSelection)
        })
    }
    
    var body: some View {
        let allSelections:[String:Any] = [
            "id" : "",
            "tutor_uid" : tutorSelection,
            "date" : dateSelection,
            "time_slot" : "0000000000000000000000000000",
            "college_class" : classSelection
        ]
        
        VStack{
            HStack{
                Text("Select a class")
                Spacer()
                Picker(classSelection, selection: $classSelection) {
                    ForEach(classes, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            HStack{
                Text("Select a tutor")
                Spacer()
                Picker(tutorSelection, selection: $tutorSelection) {
                    ForEach(tutors, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            
            DatePicker(
                "Select a date",
                selection: dateProxy,
                in: Date()...,
                displayedComponents: [.date]
            )
            .id(dateSelection)
            VStack{
                Text("available times")
                Picker("availableTimes",selection: $sessionSelections){
                    ForEach(sessionViewModel.avaialable_times, id: \.self){ pair in
                        let _ = print(pair)
                        Text(pair[0]).tag(pair)
//                        Text("Hi")
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            
            Button(action: {sessionViewModel.createSessionObject(content: allSelections)}) {
                Text("Book session")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemIndigo))
                    .cornerRadius(12)
                    .padding()
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        
        
        
    }
    
    
}
