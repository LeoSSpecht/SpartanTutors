//
//  FirstLogin_User.swift
//  SpartanTutors
//
//  Created by Leo on 6/13/22.
//

import SwiftUI

struct FirstLogin_User: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject var createUserModel = UserCreationModel()
    
    var body: some View {
        VStack{
            
//            Image("favicon")
//                .resizable().scaledToFit()
//                .frame(width: 100, height: 100)
            
            Text("Spartan Tutors")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
            
            Divider()
                .background(Color.green)
//                .padding(.bottom, 30.0)
           
            Text("We just need some information before we get started")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
                

            VStack{
                TextBox(variable: $createUserModel.name, text: "Name")
                TextBox(variable: $createUserModel.major, text: "Major")
                TextBox(variable: $createUserModel.phone, text: "Phone")
                TextBox(variable: $createUserModel.yearStatus, text: "Grade Level (Ex: Freshman)")
            }
            .padding()

            Button(action:{
                createUserModel.createUser(
                    uid: viewModel.userID.uid
                )
                viewModel.userID.isNewUser = false
                print("Log user")
            }){
                Text("Submit information")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.blue))
                    .cornerRadius(12)
                    .padding()
            }
        }
    }
}

struct TextBox:View{
    @Binding var variable:String
    var text:String
    
    var body: some View{
        ZStack{
            TextField(text, text: $variable)
                .padding()
                .multilineTextAlignment(.center)
            RoundedRectangle(cornerRadius:10)
                .stroke(lineWidth: 3)
                .fill(Color.green)
        }
        .frame(maxHeight: 50)
        .padding(3)
    }
}
struct FirstLogin_User_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            FirstLogin_User()
        }
    }
}
