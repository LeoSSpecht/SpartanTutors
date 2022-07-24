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
        ZStack(alignment: .trailing){
            RoundedRectangle(cornerRadius: 20.0)
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
    @EnvironmentObject var sessionModel: AllSessionsModel
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 20.0)
                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
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
                    if details.status == "Approved" && details.date >= Date(){
                        Button(action:{
                            UIPasteboard.general.string = tutor_detail.zoom_link
                        }){
                            HStack{
                                Image(systemName: "doc.on.clipboard")
                                    .imageScale(.small)
                                Text("Copy zoom link")
                                    
                            }
                            .foregroundColor(.black)
                        }
                    }
                    else if details.status == "Pending" && details.date >= Date(){
                        Button(action: {
                            sessionModel.cancel_session(session: details)
                        }){
                            HStack{
                                Text("Cancel session")
                                    .foregroundColor(.black)
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color(red: 0.82, green: 0.1, blue: 0.1))
                                    .imageScale(.medium)
                            }
                        }.padding(.top, 0.5)
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
    return Color(red: 0.82, green: 0.1, blue: 0.1)
}
