//
//  FirstLogin_User.swift
//  SpartanTutors
//
//  Created by Leo on 6/13/22.
//

import SwiftUI

struct FirstLogin_User: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var name:String = ""
    @State var major:String = ""
    @State var phone:String = ""
    @State var yearStatus:String = ""
    
    var createUserModel = UserCreationModel()
    var body: some View {
        let userData: [String:String] = [
            "major": name,
            "name":  major,
            "phone": phone,
            "yearStatus":yearStatus,
            "role": "student"
        ]
        VStack{
            TextField("Name", text: $name)
            TextField("Major", text: $major)
            TextField("Phone", text: $phone)
            TextField("Year", text: $yearStatus)
            Button("Submit information", action:{
                createUserModel.createUser(
                    uid: viewModel.userID.uid, userInfo: userData
                )
                viewModel.userID.isNewUser = false
            })
        }
        
    }
}
