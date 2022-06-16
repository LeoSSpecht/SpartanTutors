//
//  SessionRowView.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct SessionRowView: View {
    var body: some View {
        Row().aspectRatio(3/1, contentMode: .fit)
    }
}

struct SessionRowView_Previews: PreviewProvider {
    static var previews: some View {
        SessionRowView()
    }
}

struct Row: View{
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(.gray)
            HStack{
                VStack(alignment: .leading){
                    Text("Mon - 01/01/2022")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("10:20 AM - 12:20 PM")
                        .fontWeight(.bold)
                    Text("Leonardo Specht")
                    Text("CSE 102")
                }
                
                Spacer()
                VStack(alignment: .trailing){
                    HStack{
                        Text("Status:")
                        Text("Pending")
                            .fontWeight(.bold)
                            .foregroundColor(Color.yellow)
                    }
                    Text("Running late")
                }
            }.padding()
        }.padding()
    }
}
