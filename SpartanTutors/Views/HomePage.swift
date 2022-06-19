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
    var currentRole:String
    var body: some View {
//    Get user role, depending on the role load certain page
        if currentRole == "student"{
            let svm = sessionScheduler(uid: viewModel.userID.uid)
//            UserHomePage(sessionViewModel: svm, user: viewModel.userID).environmentObject(svm)
            UserHomePage(sessionViewModel: svm, user: viewModel.userID)
        }
        else if currentRole == "tutor"{
            TutorHomePage()
        }
        else if currentRole == "admin"{
            AdminHomePage()
        }
        else{
            Text("There was an error, please try again")
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
