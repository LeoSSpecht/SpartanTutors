//
//  ContentView.swift
//  SpartanTutors
//
//  Created by Leo on 6/11/22.
//

import SwiftUI
import Firebase
import FirebaseCore
import GoogleSignIn

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var roleModel: getRoleModel = getRoleModel()
    @State var first_animation = false
    @State var second_animation = false
    
    init(_ id: String){
        if id != ""{
            roleModel.getRole(uid: id)
        }
    }
    
    var body: some View {
        if viewModel.userID.isSignedIn {
          // User is signed in.

            if roleModel.isLoading{
                //Loading page
                Spacer()
                Header_begin()
                Spacer()
            }
            
            else if(roleModel.isFirstSignIn){
                FirstLogin_User()
            }
            
            else if !roleModel.error{
                if(roleModel.userRole != ""){
                    let animation_time = 0.5
                    ZStack{
                        VStack{
                            if second_animation{
                                HomeView(isTutorApproved: roleModel.isTutorApproved, isTutorFirstSignIn:roleModel.isTutorFirstSignIn,
                    currentRole: roleModel.userRole)
                            }
                        }
                        .animation(.easeInOut(duration: animation_time))
                        if !second_animation{
                            Header_Animation(animationStarter: first_animation)
                                .animation(.easeInOut(duration: animation_time),value: first_animation)
                                .transition(
                                    .asymmetric(
                                        insertion: .identity,
                                        removal: .opacity.animation(
                                            .easeIn(duration: animation_time)
                                                .delay(animation_time)
                                        )))
                        }
                    }
                    .onAppear{
                        first_animation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + animation_time) {
                            second_animation = true
                        }
                    }
                    .onDisappear{
                        first_animation = false
                        second_animation = false
                    }
                }
            }
            else{
                //Error
                Text("An error occured")
                let _ = print(viewModel.userID.uid)
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
            
        } else {
          // No user is signed in.
            if viewModel.loadedCheckSignIn{
                LoginView()
            }
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    @StateObject static var viewModel = AuthenticationViewModel()
//    static var previews: some View {
//        Group {
//            ContentView()
//                .environmentObject(viewModel)
//        }
//    }
//}

