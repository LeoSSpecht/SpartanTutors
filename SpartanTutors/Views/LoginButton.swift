//
//  LoginButton.swift
//  SpartanTutors
//
//  Created by Leo on 6/11/22.
//
import SwiftUI
import GoogleSignIn
import Firebase
import FirebaseCore

struct GoogleSignInButton: UIViewRepresentable {
  @Environment(\.colorScheme) var colorScheme
  
  private var button = GIDSignInButton()

  func makeUIView(context: Context) -> GIDSignInButton {
    button.colorScheme = colorScheme == .dark ? .dark : .light
    button.style = .standard
    return button
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    button.colorScheme = colorScheme == .dark ? .dark : .light
  }
}
