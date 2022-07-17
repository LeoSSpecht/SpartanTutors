//
//  TutorHomePage.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct TutorHomePage: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var tutorSessionsViewModel = TutorAllSessionsViewModel()
    var id:String
    
    init(_ id: String){
        self.id = id
        self.tutorSessionsViewModel.initiate(id)
    }
    
    var body: some View {
        Header_end()
        TabView(){
            allSessionsTutor(sessions: tutorSessionsViewModel.specific_tutor_sessions, names: tutorSessionsViewModel.studentNames)
                .tabItem{
                    Label("My sessions", systemImage: "calendar")
                }
            updateScheduleView(self.id)
                .tabItem{
                    Label("My schedule", systemImage: "square.and.pencil")
                }
            
            
            
            
            Button(action: viewModel.signOut) {
              Text("Sign out")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemIndigo))
                .cornerRadius(12)
                .padding()
            }.tabItem{
                Label("My account", systemImage: "person.circle")
            }
        }.animation(nil)
    }
}
