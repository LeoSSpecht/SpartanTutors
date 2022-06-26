//
//  bookSessionView.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct bookSessionView: View {
    @ObservedObject var bookViewModel: bookStudentSession
    @Binding var show_book_view: Bool
    @State var load_confirmation = false
    
    init(student_id:String,show_book:Binding<Bool>){
        bookViewModel = bookStudentSession(student_id: student_id)
        _show_book_view = show_book
    }
    
    private var dateProxy:Binding<Date> {
        Binding<Date>(get: {self.bookViewModel.dateSelection }, set: {
            self.bookViewModel.dateSelection = $0
            bookViewModel.update_times()
        })
    }
    
    private var tutorProxy:Binding<TutorClass> {
        Binding<TutorClass>(get: {self.bookViewModel.tutorSelection }, set: {
            self.bookViewModel.tutorSelection = $0
            bookViewModel.update_times()
            print(bookViewModel.classes_)
            print(bookViewModel.tutors)
            print(bookViewModel.available_times)
        })
    }
    
    private var classProxy:Binding<String> {
        Binding<String>(get: {self.bookViewModel.classSelection }, set: {
            self.bookViewModel.classSelection = $0
            bookViewModel.update_tutor_selection()
            bookViewModel.update_times()
        })
    }
    
    var body: some View {

        VStack{
            HStack{
                Text("Select a class")
                Spacer()
                Picker(bookViewModel.classSelection, selection: classProxy) {
                    ForEach(bookViewModel.classes_, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            
            HStack{
                Text("Select a tutor")
                Spacer()
                Picker(bookViewModel.tutorSelection.tutorName, selection: tutorProxy) {
                    Text("Any").tag(TutorClass(id: "Any", tutorName: "Any", classes: []))
                    ForEach(bookViewModel.tutors, id: \.self) { item in
                        Text(item.tutorName).tag(item)
                    }
                }
            }
            
            DatePicker(
                "Select a date",
                selection: dateProxy,
                in: Date()...,
                displayedComponents: [.date]
            )
            .id(self.bookViewModel.dateSelection)
            
            VStack{
                Text("available times")
                Picker("availableTimes",selection: $bookViewModel.sessionSelections){
                    ForEach(bookViewModel.available_times, id: \.self){ pair in
                        Text(pair[0]).tag(pair as Array<String>?)
                    }
                }
//                This line solves a bug in swift, prevents from crashing
                .id(UUID())
                .pickerStyle(WheelPickerStyle())
            }
            
            NavigationLink(
                destination: ConfirmSessionView(bookViewModel: bookViewModel,show_book_view: $show_book_view)
                ,isActive: $load_confirmation
            ){
                EmptyView()
            }.isDetailLink(false)
            
            Button(action: {

                load_confirmation.toggle()
                print("Going to confirmation")
            }) {
                Text("Book session")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(self.bookViewModel.sessionSelections != nil ? .systemIndigo: .gray))
                    .cornerRadius(12)
                    .padding()
            }.disabled(!(self.bookViewModel.sessionSelections != nil))
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        .onAppear(){
//            This updates the available times whenever  the view is opened
//            Another option is to add a listener that updates the view every time the schedule changes
//            the problem would be when one student selects the time when another student is looking at it
//            This would cause the time to disapear
            self.bookViewModel.getTutorSchedules()
        }
        
        
        
    }
    
    
}
