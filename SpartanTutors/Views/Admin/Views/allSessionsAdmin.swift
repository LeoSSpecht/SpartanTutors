//
//  allSessionsAdmin.swift
//  SpartanTutors
//
//  Created by Leo on 6/26/22.
//

import SwiftUI

struct allSessionsAdmin: View {
//    Change this to environmentObject
    @ObservedObject var sessionModel: AdminAllSessions
    var body: some View {

        let confirmed = sessionModel.studentSessions.filter{ session in
            session.status == "Approved"
        }
        let confirmed_sorted = confirmed.sorted{
            $0.date > $1.date
        }
        
        let other_Sessions = sessionModel.studentSessions.filter{session in
            session.status != "Approved"
        }
        let other_sorted = other_Sessions.sorted{
            $0.date > $1.date
        }
        
        ScrollView{
            Text("Upcoming sessions")
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
            ForEach(confirmed_sorted){ session in
                AdminRowView(sessionDetail: session,
                             s_name: sessionModel.studentNames[session.student_uid]!,
                             t_name: sessionModel.tutorNames[session.tutor_uid]!)
            }.padding(.horizontal, 5.0)
            
            Text("Past or canceled sessions")
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
            ForEach(other_sorted){ session in
                AdminRowView(sessionDetail: session,
                             s_name: sessionModel.studentNames[session.student_uid]!,
                             t_name: sessionModel.tutorNames[session.tutor_uid]!)
            }.padding(.horizontal, 5.0)
        }
    }
}
