//
//  SessionSelectionObject.swift
//  SpartanTutors
//
//  Created by Leo on 7/9/22.
//

import SwiftUI

struct SessionSelectionObject: View {
    @ObservedObject var ViewModel: bookStudentSession
    var body: some View {
        VStack{
            Text("Select starting time")
            ScrollView(.horizontal){
                LazyHStack{
                    ForEach(ViewModel.available_times){i in
                        TimeCell(session: i)
                            .onTapGesture {
                                ViewModel.choose_session(i.id)
                            }
                    }
                }.padding()
            }
        }
        
    }
}

struct TimeCell:View{
//    var time: String
//    var isSelected: Bool
    var session: sessionTime
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .stroke(session.selected ? Color.blue : Color.gray, lineWidth: 3)
                .foregroundColor(.white)
            Text(session.time_string)
        }
        .aspectRatio(2.5, contentMode: .fit)
        .frame(height:45)
    }
    
}
