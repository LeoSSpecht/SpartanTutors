//
//  bookSessionView.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct bookSessionView: View {
    @ObservedObject var sessionViewModel: SessionsVM
    
    @State private var classSelection = "CSE 102"
    @State private var tutorSelection = "Leo"
    @State private var dateSelection:Date = Date()
    @State private var sessionSelections:String = ""
    
    let classes = ["CSE 102", "CSE 231", "CSE 232"]
    let availableTimes = ["8:30-10:30","9:00-11:00"]
    let tutors = ["Leo","Chris"]
    
    
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
                selection: $dateSelection,
                in: Date()...,
                displayedComponents: [.date]
            )
            .id(dateSelection)
            
            VStack{
                Text("available dates")
                Picker("availableTimes",selection: $sessionSelections){
                    ForEach(availableTimes, id: \.self) { item in
                        Text(item)
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
