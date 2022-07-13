//
//  allSessionsView.swift
//  SpartanTutors
//
//  Created by Leo on 6/18/22.
//

import SwiftUI

struct allSessionsView: View {
    @EnvironmentObject var sessionModel: AllSessionsModel

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
                var tutor_detail = sessionModel.tutors.first(where: {$0.id == session.tutor_uid})!
                SessionRowView(details: session,tutor_detail: tutor_detail)
            }.padding(.horizontal, 5.0)
            
            Text("Past or canceled sessions")
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
            ForEach(other_sorted){ session in
                var tutor_detail = sessionModel.tutors.first(where: {$0.id == session.tutor_uid})!
                SessionRowView(details: session,tutor_detail: tutor_detail)
            }.padding(.horizontal, 5.0)
        }
    }
}
