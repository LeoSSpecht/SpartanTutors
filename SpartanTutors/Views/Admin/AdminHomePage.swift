//
//  AdminHomePage.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct AdminHomePage: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var body: some View {
        VStack{
            Text("Admin page")
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

struct AdminHomePage_Previews: PreviewProvider {
    static var previews: some View {
        AdminHomePage()
    }
}
