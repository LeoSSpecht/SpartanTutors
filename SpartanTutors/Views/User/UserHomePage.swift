//
//  UserHomePage.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct UserHomePage: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var show_book_view = false
    //Maybe change this to observable object
    @ObservedObject var sessionViewModel: AllSessionsModel
    @ObservedObject var bookSessionViewModel: bookStudentSession
    var id: String
    
    init(id: String){
        self.id = id
        sessionViewModel = AllSessionsModel(uid: id)
        bookSessionViewModel = bookStudentSession(student_id: id)
    }
    
    var body: some View {
//        Header_end()
        TabView{
//            bookSessionView(student_id:self.id)
            bookSessionView().environmentObject(bookSessionViewModel)
                .tabItem{
                    Label("Book", systemImage: "calendar")
                }
//            allSessionsView(sessionModel: sessionViewModel)
            allSessionsView().environmentObject(sessionViewModel)
                .tabItem{
                    Label("My sessions", systemImage:"square.and.pencil")
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
                Label("My account",systemImage:"person.circle")
            }
        }.animation(nil)
    }
}
