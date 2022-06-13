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
    
    var body: some View {
        if Auth.auth().currentUser != nil {
          // User is signed in.
            if(viewModel.userState == .newUser){
                FirstLogin_User()
            }
            else{
                HomeView()
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

