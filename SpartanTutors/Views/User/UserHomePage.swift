//
//  UserHomePage.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct UserHomePage: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var tab_vm = tab_selection()
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
        Header_end()
        TabView(selection: $tab_vm.selection){
            bookSessionView().environmentObject(bookSessionViewModel).environmentObject(tab_vm)
                .tabItem{
                    Label("Book", systemImage: "calendar")
                }
                .tag(1)
            allSessionsView().environmentObject(sessionViewModel)
                .tabItem{
                    Label("My sessions", systemImage:"square.and.pencil")
                }
                .tag(2)
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
            .tag(3)
        }.animation(nil)
    }
}
