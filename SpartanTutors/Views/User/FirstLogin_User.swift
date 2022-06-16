//
//  FirstLogin_User.swift
//  SpartanTutors
//
//  Created by Leo on 6/13/22.
//

import SwiftUI

struct FirstLogin_User: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var createUserModel = UserCreationModel()
    var body: some View {
        Button("Submit information", action:{
            viewModel.userID.isNewUser = false
            let someDict:[String:String] = [
                "availableClasess": "CSE 231",
                "bio": "Hi I am leo",
                "major": "CS",
                "name": "Leonardo",
                "phone": "9087747852",
                "role":"student",
                "venmoUsername":"LeoSpecht",
                "yearStatus":"Senior",
            ]
            createUserModel.createUser(
                uid: viewModel.userID.uid, userInfo: someDict
            )
        })
    }
}
