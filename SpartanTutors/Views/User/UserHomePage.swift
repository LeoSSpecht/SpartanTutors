//
//  UserHomePage.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct UserHomePage: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
//    @ObservedObject var sessionViewModel: sessionScheduler
    @State var show_book_view = false
    var sessionViewModel: AllSessionsModel
    var user: userObject
    var body: some View {
        VStack{
            NavigationView {
                VStack{
//                    NavigationLink(destination: NavigationLazyView(bookSessionView(student_id: user.uid))) {
                    NavigationLink(destination: bookSessionView(student_id: user.uid,show_book: $show_book_view),isActive: $show_book_view) {
//                        Text("Book a session")
                        EmptyView()
                    }
                    Button(action: {
                            show_book_view.toggle()
                    }){
                        Text("Book a session")
                    }
                    let _ = print(
                        sessionViewModel.studentSessions.count)
                    NavigationLink(destination: allSessionsView(sessionModel: sessionViewModel)) {
                        VStack{
                            Text("See my sessions")
                        }
                    }
                    Button(action: viewModel.signOut) {
                      Text("Sign out")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemIndigo))
                        .cornerRadius(12)
                        .padding()
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .padding()
            
        }
    }
}

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
//struct UserHomePage_Previews: PreviewProvider {
//    static var previews: some View {
//        UserHomePage()
//    }
//}
