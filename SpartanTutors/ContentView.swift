//
//  ContentView.swift
//  SpartanTutors
//
//  Created by Leo on 6/11/22.
//

import SwiftUI
import Firebase
import FirebaseCore
import GoogleSignIn

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var roleModel: getRoleModel = getRoleModel()
    var body: some View {
        if viewModel.userID.isSignedIn {
          // User is signed in.
//          ADD LOADING PAGE WHILE IT GETS ROLE
            var _: () = roleModel.getRole(uid: viewModel.userID.uid)
            if(roleModel.isFirstSignIn){
                FirstLogin_User()
            }
            else{
                if(roleModel.userRole != ""){
                    HomeView(isTutorApproved: roleModel.isTutorApproved, isTutorFirstSignIn:roleModel.isTutorFirstSignIn,
                        currentRole: roleModel.userRole)
                }
                else{
                    Text("An error occured")
                    let _ = print(viewModel.userID.uid)
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
            
        } else {
          // No user is signed in.
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

