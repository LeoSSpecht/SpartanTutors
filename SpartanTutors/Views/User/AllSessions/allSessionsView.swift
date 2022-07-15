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
        ScrollView{
            Text("Upcoming sessions")
                .font(.title2)
            Loop_rows(list: sessionModel.confirmed)
            
            Text("Past or canceled sessions")
                .font(.title2)
            Loop_rows(list: sessionModel.other_Sessions)
        }
    }
}

struct Loop_rows: View{
    @EnvironmentObject var sessionModel: AllSessionsModel
    var list: Array<Session>
    var body: some View{
        ForEach(list){ session in
            let tutor_detail = sessionModel.tutors.first(where: {$0.id == session.tutor_uid})!
            SessionRowView(details: session,tutor_detail: tutor_detail)
        }.padding(.horizontal, 5.0)
    }
}
