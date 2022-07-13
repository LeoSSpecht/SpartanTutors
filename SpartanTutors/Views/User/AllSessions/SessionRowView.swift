//
//  SessionRowView.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import SwiftUI

struct SessionRowView: View {
    var details:Session
    var tutor_detail: TutorSummary
    var body: some View {
        Row(details: details,tutor_detail: tutor_detail).aspectRatio(2.5/1, contentMode: .fit)
    }
}
//
//struct SessionRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionRowView(details: Session([
//                    "id":"123",
//                    "student_uid":"leo",
//                    "tutor_uid":"master",
//                    "date": Date(),
//                    "time_slot": "0222200000000000000000000000",
//                    "college_class":"CSE",
//            "status": "Approved"
//        ]))
//    }
//}

struct Row: View{
    var details: Session
    var tutor_detail: TutorSummary
    var body: some View{
        ZStack(alignment: .trailing){
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(get_Status_Color(detail: details))
                .shadow(radius: 3)
            InnerRow(details: details,tutor_detail: tutor_detail)
                .padding(.leading, 10)
        }
    
    }
}

struct InnerRow: View{
    var details: Session
    var tutor_detail: TutorSummary
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(.gray)
//                .shadow(radius: 5)
            HStack{
                VStack(alignment: .leading){
                    Text(details.date.to_WeekDay_date())
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(details.get_time_frame())
                        .fontWeight(.bold)
                    Text(tutor_detail.name)
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
                    HStack{
                        Image(systemName: "doc.on.clipboard")
                            .imageScale(.small)
                        Text("Copy zoom link")
                    }.onTapGesture{
                        UIPasteboard.general.string = tutor_detail.zoom_link
                    }
                    
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
