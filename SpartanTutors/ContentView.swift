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
    @State var animationStarter = false
    @State var opacityStarter = false
    @State var hide_header = false
    
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
                    VStack{
                        //MARK: Title
//                        if !hide_header{
                            Header_Animation(animationStarter: animationStarter)
//                                .transition(.asymmetric(insertion: .identity, removal: .opacity))
//                        }
                        //MARK: View loading
                        if animationStarter{
                            VStack{
                                if opacityStarter{
                                    HomeView(isTutorApproved: roleModel.isTutorApproved, isTutorFirstSignIn:roleModel.isTutorFirstSignIn,
                                             currentRole: roleModel.userRole)
                                        .transition(
                                            AnyTransition.scale
//                                                .combined(with: .move(edge: .bottom))
                                                .animation(.linear(duration: animation_time).delay(animation_time/2))
                                        )
                                }
                            }
                            .onAppear{
                                withAnimation{
                                    opacityStarter = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + animation_time) {
                                        // your code here
                                        hide_header = true
                                    }
                                }
                            }
                        }
                    }
                    //Animation for the title
                    .animation(.easeInOut(duration: animation_time))
                    .onAppear{
                        animationStarter = true
                    }.onDisappear{
                        animationStarter = false
                        opacityStarter = false
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

