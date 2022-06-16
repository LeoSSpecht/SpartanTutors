//
//  UserHomePage.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct UserHomePage: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var sessionViewModel: SessionsVM
    var user: userObject
    var body: some View {
        VStack{
            NavigationView {
                VStack{
                    NavigationLink(destination: bookSessionView(sessionViewModel: sessionViewModel)) {
                        Text("Book a session")
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
//            .navigationTitle("Actions")
            .padding()
            
        }
    }
}

//struct UserHomePage_Previews: PreviewProvider {
//    static var previews: some View {
//        UserHomePage()
//    }
//}
