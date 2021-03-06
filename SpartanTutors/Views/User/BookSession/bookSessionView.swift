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
//    @State var load_confirmation = false
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
            self.bookViewModel.tutorSelection = TutorSummary(id: "Any", name: "Any")
            bookViewModel.update_times()
        })
    }
    
    var body: some View {
        if !bookViewModel.finishedLoading{
            VStack{
                Header_end()
                LoadingCircle()
            }
        }
        else{
            NavigationView{
                VStack{
                    Header_end()
                    Spacer(minLength: 50)

                    HStack{
                        Text("Select a class")
                        Spacer()
                        
                        Menu{
                            Picker(selection: classProxy, label: EmptyView()) {
                                ForEach(bookViewModel.classes_, id: \.self) { item in
                                    Text(item)
                                }
                            }
                        }label: {
                            picker_label(selection: self.bookViewModel.selectedClass)
                        }
                    }.padding(.horizontal)

                    HStack{
                        Text("Select a tutor")
                        Spacer()
                        Menu{
                            Picker(selection: tutorProxy, label: EmptyView()
                            ) {
                                Text("Any").tag(TutorSummary(id: "Any", name: "Any"))
                                ForEach(bookViewModel.tutors, id: \.self) { item in
                                    Text(item.name).tag(item)
                                }
                            }
                        }label: {
                            picker_label(selection: self.bookViewModel.tutorSelection.name)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                    }.padding(.horizontal)

                    CalendarView(calendarViewModel: calendarViewModel,selected_date: dateProxy)
                    SessionSelectionObject(ViewModel: bookViewModel)
                        .frame(maxHeight: 300)
                    
                    NavigationLink(
                        destination: ConfirmSessionView()
                        ,isActive: self.$bookViewModel.load_confirmation
                    ){
                        EmptyView()
                    }.isDetailLink(false)

                    Button(action: {
                        print("Status after: \(self.bookViewModel.load_confirmation)")
                        self.bookViewModel.load_confirmation = true
                        print("Status after: \(self.bookViewModel.load_confirmation)")
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
                .navigationBarHidden(true)
            }
            .popup(isPresented: $bookViewModel.error_on_book, type: .toast, position: .top, autohideIn: 3) {
                PopUpBody(text: "Sorry there was an error when booking your session please try again", color: Color(red: 1, green: 0.8, blue: 0.8))
            }
        }
    }
}

struct picker_label:View {
    var selection: String
    
    var body: some View{
        HStack{
            Text(selection)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
                .frame(maxWidth: 10)
            Image(systemName: "chevron.down")
                .foregroundColor(.gray)
        }
        .padding(.vertical,5)
        .padding(.horizontal,10)
        .background(
            Capsule()
                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
        )
    }
}
