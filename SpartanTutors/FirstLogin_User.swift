//
//  FirstLogin_User.swift
//  SpartanTutors
//
//  Created by Leo on 6/13/22.
//

import SwiftUI

struct FirstLogin_User: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        Button("Submit information", action:{
            viewModel.userState = .notNew
        })
    }
}
