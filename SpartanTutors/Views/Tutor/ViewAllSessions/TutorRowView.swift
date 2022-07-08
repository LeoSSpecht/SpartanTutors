//
//  TutorRowView.swift
//  SpartanTutors
//
//  Created by Leo on 6/30/22.
//

import SwiftUI

struct TutorRowView: View {
//    @ObservedObject var all_sessions_view_model = AdminAllSessions()
    var sessionDetail:Session
    var student_name: String
    var body: some View {
        TutorRow(details: sessionDetail,student_name: student_name).aspectRatio(2.5/1, contentMode: .fit)
    }
}

struct TutorRow: View{
    var details: Session
    var student_name: String
    var body: some View{
        ZStack(alignment: .trailing){
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(get_Status_Color(detail: details))
                .shadow(radius: 3)
            InnerTutorRow(details: details,student_name:student_name)
                .padding(.leading, 10)
        }
    
    }
}

struct InnerTutorRow: View{
    var details: Session
    var student_name: String
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
            HStack{
                VStack(alignment: .leading){
                    Text(details.date_to_string())
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(details.get_time_frame())
                        .fontWeight(.bold)
                    Text("Student: \(student_name)") //Student
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

