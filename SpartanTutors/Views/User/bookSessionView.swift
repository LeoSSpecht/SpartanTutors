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
    @State private var dateSelection = Date()
    
    let classes = ["CSE 102", "CSE 231", "CSE 232"]
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
            HStack{
                Text("Select a date")
                Spacer()
                DatePicker(
                    "",
                    selection: $dateSelection,
                    in: Date()...,
                    displayedComponents: [.date])
            }
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
