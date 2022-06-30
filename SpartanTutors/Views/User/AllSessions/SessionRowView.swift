//
//  SessionRowView.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct SessionRowView: View {
    var details:Session
    var body: some View {
        Row(details: details).aspectRatio(2.5/1, contentMode: .fit)
    }
}

struct SessionRowView_Previews: PreviewProvider {
    static var previews: some View {
        SessionRowView(details: Session([
                    "id":"123",
                    "student_uid":"leo",
                    "tutor_uid":"master",
                    "date": Date(),
                    "time_slot": "0222200000000000000000000000",
                    "college_class":"CSE",
            "status": "Approved"
        ]))
    }
}

struct Row: View{
    var details: Session
    var body: some View{
        ZStack(alignment: .trailing){
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(get_Status_Color(detail: details))
                .shadow(radius: 3)
            InnerRow(details: details)
                .padding(.leading, 10)
        }
    
    }
}

struct InnerRow: View{
    var details: Session
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(.gray)
//                .shadow(radius: 5)
            HStack{
                VStack(alignment: .leading){
                    Text(details.date_to_string())
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(details.get_time_frame())
                        .fontWeight(.bold)
                    Text("Leo")
                    Text(details.college_class)
                }
                
                Spacer()
                VStack(alignment: .trailing){
                    HStack{
                        Text("Status:")
                        Text(details.status)
                            .fontWeight(.bold)
                            .foregroundColor(get_Status_Color(detail: details))
                    }
                    Text("Running late")
                }
            }.padding()
        }
    }
}

func get_Status_Color(detail:Session) -> Color{
    let status = detail.status
    if status == "Approved"{
        return .green
    }
    else if status == "Pending"{
        return .yellow
    }
    return .red
}
