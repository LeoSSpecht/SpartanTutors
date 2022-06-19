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
                    "time_slot": "8:30",
                    "college_class":"CSE"
                ]))
    }
}

struct Row: View{
    var details: Session
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(.gray)
                .shadow(radius: 5)
            HStack{
                VStack(alignment: .leading){
//                    Text("Mon - 01/01/2022")
                    Text(Date_to_string(date: details.date))
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("10:20 AM - 12:20 PM")
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
    
    func Date_to_string(date: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "eee MM/dd/YYYY"
        let formatted = df.string(from: date)
        return formatted
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
}
