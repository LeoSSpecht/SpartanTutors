//
//  SpartanTutorsApp.swift
//  SpartanTutors
//
//  Created by Leo on 6/11/22.
//

import SwiftUI
import FirebaseCore
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let settings = FirestoreSettings()
    settings.isPersistenceEnabled = false
    FirebaseApp.configure()
    Firestore.firestore().settings = settings
    return true
  }
}
    
@main
struct SpartanTutorsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthenticationViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel.userID.uid).environmentObject(viewModel)
        }
    }
}
