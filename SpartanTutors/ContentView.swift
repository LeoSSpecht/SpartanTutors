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
    @State var loadHomeView = false
    
    init(_ id: String){
        if id != ""{
            roleModel.getRole(uid: id)
        }
    }
    
    var body: some View {
        if viewModel.userID.isSignedIn {
          // User is signed in.
            let Title = Text("Spartan Tutors")
                .fontWeight(.bold)
                .font(.largeTitle)
                .scaleEffect(1)
                .foregroundColor(Color(red: 0.11, green: 0.34, blue: 0.17))
            if roleModel.isLoading{
                //Loading page
                Spacer()
                Title
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
                        HStack(spacing: 0){
                            //Title
                            Spacer()
                                .frame(maxWidth: .infinity)
                            Title
                                .scaleEffect(animationStarter ? 0.5 : 1)
                                .frame(alignment: .center)
                                .layoutPriority(1)

//                          Menu for sign out
                            if opacityStarter{
                                Menu{
                                    Button("Sign out",action:{viewModel.signOut()})
                                } label: {
                                    Image(systemName: "gear").padding().frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            else{
                                Spacer().frame(maxWidth: .infinity)
                            }
                        }
//                        .frame(maxHeight:50)
                        
                        //MARK: View loading
                        if animationStarter{
                            VStack{
                                if opacityStarter{
                                    HomeView(isTutorApproved: roleModel.isTutorApproved, isTutorFirstSignIn:roleModel.isTutorFirstSignIn,
                                             currentRole: roleModel.userRole)
                                        .transition(
                                            AnyTransition.opacity
//                                                .combined(with: .move(edge: .bottom))
                                                .animation(.linear(duration: animation_time).delay(animation_time/2))
                                        )
                                }
                            }
                            .onAppear{
                                withAnimation{
                                    opacityStarter = true
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
            LoginView()
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

