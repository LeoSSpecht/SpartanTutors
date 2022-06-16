//
//  HomePage.swift
//  SpartanTutors
//
//  Created by Leo on 6/11/22.
//

import SwiftUI
import GoogleSignIn
import Firebase
import FirebaseCore
struct HomeView: View {
  // 1
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var currentRole = "admin"
    var body: some View {
//    Get user role, depending on the role load certain page
    
    if currentRole == "user"{
        UserHomePage()
    }
    else if currentRole == "tutor"{
        TutorHomePage()
    }
    else{
        AdminHomePage()
    }
//    NavigationView {
//      VStack {
//        HStack {
//          // 3
//
//          VStack(alignment: .leading) {
//            Text(viewModel.userID.name)
//              .font(.headline)
//
////            Text(user?.profile?.email ?? "")
////              .font(.subheadline)
//          }
//
//          Spacer()
//        }
//        .padding()
//        .frame(maxWidth: .infinity)
//        .background(Color(.secondarySystemBackground))
//        .cornerRadius(12)
//        .padding()
//
//        Spacer()
//
//        // 4
//        Button(action: viewModel.signOut) {
//          Text("Sign out")
//            .foregroundColor(.white)
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(Color(.systemIndigo))
//            .cornerRadius(12)
//            .padding()
//        }
//      }
//      .navigationTitle("Ellifit")
//    }
//    .navigationViewStyle(StackNavigationViewStyle())
  }
}
