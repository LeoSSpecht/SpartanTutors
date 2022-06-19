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
    var sessionViewModel: sessionScheduler
    var user: userObject
    var body: some View {
        VStack{
            NavigationView {
                VStack{
                    NavigationLink(destination: NavigationLazyView(bookSessionView(VM: sessionViewModel))) {
                        Text("Book a session")
                    }
                    let _ = print(sessionViewModel.studentSessions.count)
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
