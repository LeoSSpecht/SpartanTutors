//
//  ContactUs.swift
//  SpartanTutors
//
//  Created by FAMILY on 6/16/22.
//

import SwiftUI

struct ContactUs: View
{
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var description:String = ""
    

    var body: some View {
        let contactUsData: [String:String] = [
            //"name": name,
            //"class":  class1,
            "description": description
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
       
        Text("Contact Us")
            .font(.headline)
            .padding(.bottom)
        
            TextField("Tell us what's on your mind", text: $description).padding().frame(width: 300, height: 150)
                .background(RoundedRectangle(cornerRadius:20).stroke(lineWidth: 3).fill(Color.green))
            
            
            Button("Submit information", action:{
            }).foregroundColor(.white).fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .padding()
            .frame(width: .infinity, height: .infinity)
            .background(RoundedRectangle(cornerRadius:20).fill(Color.blue).shadow(radius: 3)).padding(.top)
            
    //        Button("Submit information", action:{
    //            createUserModel.createUser(
    //                uid: viewModel.userID.uid, userInfo: userData
    //            )
    //            viewModel.userID.isNewUser = false
    //        }).foregroundColor(.white).fixedSize(horizontal: false, vertical: true)
    //        .multilineTextAlignment(.center)
    //        .padding()
    //        .frame(width: 250, height: 50)
    //        .background(RoundedRectangle(cornerRadius:20).fill(Color.blue).shadow(radius: 3)).padding(.top)
          
            
        }
  
        
    }
}























struct ContactUs_Previews: PreviewProvider {
    static var previews: some View {
        ContactUs()
    }
}
