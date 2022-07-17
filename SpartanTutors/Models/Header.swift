//
//  Header.swift
//  SpartanTutors

import SwiftUI

struct Header_Animation: View {
    var animationStarter: Bool
    var body: some View {
        VStack{
            //Title
            Header_begin()
                .scaleEffect(animationStarter ? 0.5 : 1)
                .frame(alignment: .center)
                .layoutPriority(1)
            if animationStarter{
                Spacer()
            }
        }
    }
}

struct Header_begin:View{
    var body: some View{
        Text("Spartan Tutors")
            .fontWeight(.bold)
            .font(.largeTitle)
            .foregroundColor(Color(red: 0.11, green: 0.34, blue: 0.17))
    }
}

struct Header_end:View{
    var body: some View{
        Text("Spartan Tutors")
            .fontWeight(.bold)
            .font(.largeTitle)
            .foregroundColor(Color(red: 0.11, green: 0.34, blue: 0.17))
            .scaleEffect(0.5)
    }
}
