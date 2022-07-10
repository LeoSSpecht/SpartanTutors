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
                        TimeCell(time: i.time_string, isSelected: i.selected)
                            .onTapGesture {
                                print("hi")
                                ViewModel.choose_session(i.id)
                            }
                    }
                }.padding()
            }
        }
        
    }
}

struct TimeCell:View{
    var time: String
    var isSelected: Bool
    var body: some View{
        let _ = print(time)
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 3)
                .foregroundColor(.white)
            Text(time)
        }
        .aspectRatio(2.5, contentMode: .fit)
        .frame(height:45)
    }
    
}
