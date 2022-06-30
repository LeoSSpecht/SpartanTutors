//
//  AuthorizationModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/11/22.
//

import Firebase
import FirebaseCore
import GoogleSignIn

class AuthenticationViewModel: ObservableObject {

    private static func checkSignIn()
    -> userObject
    {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil{
            return userObject(
                isSignedIn: true,
                uid: currentUser?.uid ?? "",
                name: currentUser?.displayName ?? "")
        }
        else{
            return userObject()
        }
    }

    // If this changes to be just a userObject(), the user will have to tap the button to log in everytime (safer)
    // Otherwise call checkSignIn here for autosignIn
    @Published var userID: userObject = userObject()
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
      // 1
      if let error = error {
        print(error.localizedDescription)
        return
      }
      guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      Auth.auth().signIn(with: credential) { [unowned self] (result, error) in
        if let error = error {
          print(error.localizedDescription)
        } else {
            guard let newUserStatus = result?.additionalUserInfo?.isNewUser else {return}
            if(newUserStatus){
//                If it is a new user, create the user in the database
                let createUserModel = UserCreationModel()
                self.userID.isNewUser = true
                createUserModel.createUser(uid: result!.user.uid,first_sign_in: true)
            }
//          gets user info
            self.userID.isSignedIn = true
            self.userID.uid = result?.user.uid ?? "Error"
            self.userID.name = result?.user.displayName ?? "Error"
        }
      }
    }
    
    func signIn() {
      // 1
      if GIDSignIn.sharedInstance.hasPreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
            authenticateUser(for: user, with: error)
        }
      } else {
        // 2
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // 3
        let configuration = GIDConfiguration(clientID: clientID)
        
        // 4
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        // 5
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in authenticateUser(for: user, with: error)}
      }
    }
    func signOut() {
      // 1
      GIDSignIn.sharedInstance.signOut()
      
      do {
        // 2
        try Auth.auth().signOut()
        
//        state = .signedOut
        userID.isSignedIn = false
      } catch {
        print(error.localizedDescription)
      }
    }
    
    
}

