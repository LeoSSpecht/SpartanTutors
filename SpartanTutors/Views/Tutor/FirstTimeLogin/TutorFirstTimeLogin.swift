//
//  TutorFirstTimeLogin.swift
//  SpartanTutors
//
//  Created by Leo on 6/30/22.
//

import SwiftUI

struct TutorFirstTimeLogin: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject var createUserModel = TutorCreationModel()
    @StateObject var allClassesViewModel = classSelectionViewModel()
    
    var body: some View {
        NavigationView{
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
               
                Text("We just need some information before we get started")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                    

                VStack{
                    NavigationLink(destination: classSelectionView(allClassesViewModel: allClassesViewModel)){
                        ZStack(alignment: .center){
                            HStack{
                                Text("Select classes you will teach")
                                Image(systemName: "arrow.right")
                            }
                            .foregroundColor(.gray)
                            RoundedRectangle(cornerRadius:10)
                                .stroke(lineWidth: 3)
                                .fill(Color.green)
                        
                        }
                        .frame(maxHeight: 50)
                        .padding(3)
                    }
                    TextBox(variable: $createUserModel.venmo, text: "Venmo username")
                }
                .padding()

                Button(action:{
                    createUserModel.updateTutor(
                        uid: viewModel.userID.uid,
                        classes: allClassesViewModel.onlySelected
                    )
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
}

struct TutorFirstTimeLogin_Previews: PreviewProvider {
    static var previews: some View {
        TutorFirstTimeLogin()
    }
}
