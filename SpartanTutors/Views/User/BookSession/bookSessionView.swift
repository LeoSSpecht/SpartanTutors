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
                VStack(alignment: .trailing){
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
//                            picker_label(selection: self.bookViewModel.tutorSelection.name)
                            tutor_picker_label
                        }
                        
                    }.padding(.horizontal)

                    CalendarView(calendarViewModel: calendarViewModel,selected_date: dateProxy)
                    SessionSelectionObject(ViewModel: bookViewModel)
                        .frame(maxHeight: 300)
                    
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
                .navigationBarHidden(true)
            }
        }
    }
    
    var tutor_picker_label: some View{
        HStack{
            Text(self.bookViewModel.tutorSelection.name)
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
