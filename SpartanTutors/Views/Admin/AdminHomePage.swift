//
//  AdminHomePage.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct AdminHomePage: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var adminViewModel = AdminAllSessions() // Change this to environment object
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Admin page")
                
                //THIS IS A FUCKING WORKAROUND FOR IOS 14, ONCE UPDATED CHANGE THE NAVIGATION VIEW STYLE TO .stack and it should work
                NavigationLink(destination: EmptyView()) {
                  EmptyView()
                }
                
                NavigationLink(destination: allSessionsAdmin(
                                sessionModel: adminViewModel)){
                    Text("View all student sessions")
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
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AdminHomePage_Previews: PreviewProvider {
    static var previews: some View {
        AdminHomePage()
    }
}
