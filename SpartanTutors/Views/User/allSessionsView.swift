//
//  allSessionsView.swift
//  SpartanTutors
//
//  Created by Leo on 6/18/22.
//

import SwiftUI

struct allSessionsView: View {
//    @ObservedObject var sessionModel: SessionsVM
    @ObservedObject var sessionModel: sessionScheduler
    
    
    var body: some View {

        let confirmed = sessionModel.studentSessions.filter{ session in
            session.status == "Approved"
        }
        
        let other_Sessions = sessionModel.studentSessions.filter{session in
            session.status != "Approved"
        }
        
        ScrollView{
            Text("Upcoming sessions")
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
            ForEach(confirmed){ session in
                SessionRowView(details: session)
            }
            
            Text("Past or canceled sessions")
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
            ForEach(other_Sessions){ session in
                SessionRowView(details: session)
            }
        }
    }
}
//
//struct allSessionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        allSessionsView(sessions: [Session([
//            "id":"123",
//            "student_uid":"leo",
//            "tutor_uid":"master",
//            "date": Date(),
//            "time_slot": "8:30",
//            "college_class":"CSE"
//        ]),
//        Session([
//            "id":"456",
//            "student_uid":"leo",
//            "tutor_uid":"p",
//            "date": Date(),
//            "time_slot": "8:30",
//            "college_class":"Math studies"
//        ]),
//        Session([
//            "id":"789",
//            "student_uid":"leo",
//            "tutor_uid":"p",
//            "date": Date(),
//            "time_slot": "8:30",
//            "college_class":"Math studiesa"
//        ])])
//    }
//}
