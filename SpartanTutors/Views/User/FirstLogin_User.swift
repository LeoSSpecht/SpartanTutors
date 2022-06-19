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
        let userData: [String:Any] = [
            "name": name,
            "major":  major,
            "phone": phone,
            "yearStatus":yearStatus,
            "role": "student",
            "firstSignIn": false
        ]
        
        VStack{
            
            Image("favicon")
                .resizable().scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("Spartan Tutors")
                .font(.headline)
                .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
            
            Divider()
                .padding(.bottom, 30.0)
           
            Text("Fill in some info here")
                .font(.headline)
                .padding(.bottom)
                
          
        TextField("Name", text: $name).padding().frame(width: 250, height: 50)
            .background(RoundedRectangle(cornerRadius:20).stroke(lineWidth: 3).fill(Color.green))
          
            
            TextField("Major", text: $major).padding().frame(width: 250, height: 50)
                .background(RoundedRectangle(cornerRadius:20).stroke(lineWidth: 3).fill(Color.green))
            
            TextField("Phone", text: $phone).padding().frame(width: 250, height: 50)
                .background(RoundedRectangle(cornerRadius:20).stroke(lineWidth: 3).fill(Color.green))
            
            TextField("Grade Level (Ex: Freshman)", text: $yearStatus).padding().frame(width: 250, height: 50)
                .background(RoundedRectangle(cornerRadius:20).stroke(lineWidth: 3).fill(Color.green))
            
            
            Button("Submit information", action:{
                createUserModel.createUser(
                    uid: viewModel.userID.uid, userInfo: userData
                )
                viewModel.userID.isNewUser = false
            }).foregroundColor(.white).fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .padding()
            .frame(width: 250, height: 50)
            .background(RoundedRectangle(cornerRadius:20).fill(Color.blue).shadow(radius: 3)).padding(.top)
            
            
        
        }
        .padding(.bottom)
        
        
        
        
        
        
        
    }
}










struct FirstLogin_User_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            FirstLogin_User()
        }
    }
}
