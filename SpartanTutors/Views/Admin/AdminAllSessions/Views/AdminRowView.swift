//
//  SwiftUIView.swift
//  SpartanTutors
//
//  Created by Leo on 6/26/22.
//

import SwiftUI

struct AdminRowView: View {
    @ObservedObject var all_sessions_view_model = AdminAllSessions()
    var sessionDetail:Session
    var s_name:String
    var t_name:String
    var body: some View {
        AdminRow(viewModel:all_sessions_view_model,
                 details: sessionDetail,
                 s_name:s_name,
                 t_name:t_name).aspectRatio(2.5/1, contentMode: .fit)
    }
}

//struct Admin_SessionRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdminRowView(sessionDetail: Session([
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

struct AdminRow: View{
    var viewModel:AdminAllSessions
    var details: Session
    var s_name:String
    var t_name:String
    var body: some View{
        ZStack(alignment: .trailing){
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(get_Status_Color(detail: details))
                .shadow(radius: 3)
            InnerAdminRow(details: details,
                          viewModel:viewModel,
                          s_name:s_name,
                          t_name:t_name)
                .padding(.leading, 10)
        }
    
    }
}

struct InnerAdminRow: View{
    var details: Session
    var viewModel:AdminAllSessions
    var s_name:String
    var t_name:String
    
    var body: some View{
        let buttons =
            HStack{
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        viewModel.changeSessionStatus(
                            session:details,
                            session_status: "Canceled")
                    }
                
                Spacer()
                    .frame(maxWidth:20)
                
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        viewModel.changeSessionStatus(
                            session:details,
                            session_status: "Approved")
                    }
                    .disabled(details.status == "Approved")
                    .opacity(details.status == "Approved" ? 0.2 : 1)
            }
        
        ZStack{
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(.gray)
            HStack{
                VStack(alignment: .leading){
                    Text(details.date.to_WeekDay_date())
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(details.get_time_frame())
                        .fontWeight(.bold)
                    
                    Text("Tutor: \(t_name)") // Tutor
                    Text("Student: \(s_name)") //Student
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
                    if details.status != "Canceled"{
                        buttons
                    }
                    Text("Running late")
                }
            }.padding()
        }
    }
}

