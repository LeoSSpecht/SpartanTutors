//
//  UserHomePage.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct UserHomePage: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
//    var viewModel_userData:FirebaseVM
    var body: some View {
        VStack{
            NavigationView{
                Text("Book a session")
                Text("View my sessions")
            }
            .navigationTitle("Landmarks")
            .padding()
            
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
}

//struct UserHomePage_Previews: PreviewProvider {
//    static var previews: some View {
//        UserHomePage()
//    }
//}
