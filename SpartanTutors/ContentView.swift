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
            var _: () = roleModel.getRole(uid: viewModel.userID.uid)
            if(roleModel.isFirstSignIn){
                FirstLogin_User()
            }
            else{
                if(roleModel.userRole != ""){
                    HomeView(currentRole: roleModel.userRole)
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

