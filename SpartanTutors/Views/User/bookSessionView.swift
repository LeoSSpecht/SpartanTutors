//
//  bookSessionView.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct bookSessionView: View {
    @State private var classSelection = "CSE 102"
    @State private var tutorSelection = "Leo"
    @State private var dateSelection:Date = Date()
    @State private var sessionSelections:String = ""
    
    let classes = ["CSE 102", "CSE 231", "CSE 232"]
    let availableTimes = ["8:30-10:30","9:00-11:00"]
    let tutors = ["Leo","Chris"]
    var body: some View {
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
            
//            Button(action: viewModel.signOut) {
            Text("Book session")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemIndigo))
                .cornerRadius(12)
                .padding()
//            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        
        
        
    }
}

struct bookSessionView_Previews: PreviewProvider {
    static var previews: some View {
        bookSessionView()
    }
}
