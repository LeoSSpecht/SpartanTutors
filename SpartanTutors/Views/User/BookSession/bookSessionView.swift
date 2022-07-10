//
//  bookSessionView.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct bookSessionView: View {
    @EnvironmentObject var bookViewModel: bookStudentSession
    @StateObject var calendarViewModel = calendarVM()
    @State var load_confirmation = false
    @State var animationAmount = 1.0
    var maxAnimation = 2.0

    private var dateProxy:Binding<Date> {
        Binding<Date>(get: {self.bookViewModel.dateSelection }, set: {
            self.bookViewModel.dateSelection = $0
            bookViewModel.update_times()
        })
    }
    
    private var tutorProxy:Binding<TutorSummary> {
        Binding<TutorSummary>(get: {self.bookViewModel.tutorSelection }, set: {
            self.bookViewModel.tutorSelection = $0
            bookViewModel.update_times()
        })
    }
    
    private var classProxy:Binding<String> {
        Binding<String>(get: {self.bookViewModel.selectedClass }, set: {
            self.bookViewModel.selectedClass = $0
            self.bookViewModel.tutorSelection = TutorSummary(id: "Any", tutorName: "Any")
            bookViewModel.update_times()
        })
    }
    
    var body: some View {
        
        //TODO:
        // Book session is not working
        // Corrigir datas invalidas podem ser selecionadas
        
        
        if !bookViewModel.finishedLoading{
            LoadingCircle()
        }
        else{
            NavigationView{
                VStack{
                    HStack{
                        Text("Select a class")
                        Spacer()
                        Picker(self.bookViewModel.selectedClass, selection: classProxy) {
                            ForEach(bookViewModel.classes_, id: \.self) { item in
                                Text(item)
                            }
                        }
                    }

                    HStack{
                        Text("Select a tutor")
                        Spacer()
                        Picker(bookViewModel.tutorSelection.tutorName, selection: tutorProxy) {
                            Text("Any").tag(TutorSummary(id: "Any", tutorName: "Any"))
                            ForEach(bookViewModel.tutors, id: \.self) { item in
                                Text(item.tutorName).tag(item)
                            }
                        }
                    }

                    CalendarView(calendarViewModel: calendarViewModel,selected_date: dateProxy).padding(0)
                    SessionSelectionObject(ViewModel: bookViewModel)
                    NavigationLink(
                        destination: ConfirmSessionView(show_confirm: $load_confirmation)
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
                .padding()
                .pickerStyle(MenuPickerStyle())
                .onAppear(){
        //            OPTIONAL: This updates the available times whenever  the view is opened
        //            Another option is to add a listener that updates the view every time the schedule changes
        //            the problem would be when one student selects the time when another student is looking at it
        //            This would cause the time to disapear
        //                self.bookViewModel.getTutorSchedules()
                }
            }
        }
    }
}
