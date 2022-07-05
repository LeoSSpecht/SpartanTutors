//
//  LoginPage.swift
//  SpartanTutors
//
//  Created by Leo on 6/11/22.
//

import SwiftUI

struct LoginView: View {

  // 1
  @EnvironmentObject var viewModel: AuthenticationViewModel

  var body: some View {
    let height:CGFloat = 55
    VStack {
        //Button here just for centering
        Button(action: {}) {
            Text("")
                .padding()
                .frame(maxWidth: .infinity)
                .padding()
                .opacity(0)
        }.disabled(true)
        
        Spacer()
        Text("Welcome to")
            .fontWeight(.bold)
            .foregroundColor(Color(red: 0.11, green: 0.34, blue: 0.17))
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .frame(height:height)
        Text("Spartan Tutors")
            .fontWeight(.bold)
            .foregroundColor(Color(red: 0.11, green: 0.34, blue: 0.17))
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            
//            .layoutPriority(1)
        // 3
        Spacer().frame(height:height)

        Spacer()
        Button(action: viewModel.signIn) {
            Text("Sign in using google")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.11, green: 0.34, blue: 0.17))
                .cornerRadius(12)
                .padding()
        }
    }
  }
}
