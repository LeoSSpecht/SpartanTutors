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
        NavigationView{
            VStack{
//
                Spacer().frame(maxHeight: 230)
                //THIS IS A FUCKING WORKAROUND FOR IOS 14, ONCE UPDATED CHANGE THE NAVIGATION VIEW STYLE TO .stack and it should work
                NavigationLink(destination: EmptyView()) {
                  EmptyView()
                }
                NavigationLink(destination: allSessionsTutor(sessions: tutorSessionsViewModel.specific_tutor_sessions, names: tutorSessionsViewModel.studentNames)){
                    Text("View scheduled sessions \(tutorSessionsViewModel.specific_tutor_sessions.count)")
                }
                .isDetailLink(false)
                .navigationBarTitleDisplayMode(.inline)
                
                NavigationLink(destination: updateScheduleView(self.id)){
                    Text("Update my schedule")
                }
                .isDetailLink(false)
                
                Text("Update my info")
                
                Spacer().frame(maxHeight:.infinity)
            }
        }
        .padding(.top,-15)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
//
//struct TutorHomePage_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorHomePage("123")
//    }
//}
