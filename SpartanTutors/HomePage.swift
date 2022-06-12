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
  
  // 2
    private let user = Auth.auth().currentUser?.displayName
  
  var body: some View {
    NavigationView {
      VStack {
        HStack {
          // 3
//          NetworkImage(url: user?.profile?.imageURL(withDimension: 200))
//            .aspectRatio(contentMode: .fit)
//            .frame(width: 100, height: 100, alignment: .center)
//            .cornerRadius(8)
          
          VStack(alignment: .leading) {
            Text(user ?? "Erro")
              .font(.headline)
            
//            Text(user?.profile?.email ?? "")
//              .font(.subheadline)
          }
          
          Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding()
        
        Spacer()
        
        // 4
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
      .navigationTitle("Ellifit")
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}
