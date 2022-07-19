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
        VStack{
            Header_end()
            ScrollView{
                VStack(alignment: .leading){
                    Text("Your Sessions")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding(.leading)
                    Text("Upcoming sessions")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding()

                        
                    Loop_rows(empty: "upcoming", list: sessionModel.confirmed)
                    
                    Text("Past or canceled sessions")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding()
                    Loop_rows(empty: "past", list: sessionModel.other_Sessions)
                }
            }
        }
    }
}

struct Loop_rows: View{
    @EnvironmentObject var sessionModel: AllSessionsModel
    var empty: String
    var list: Array<Session>
    var body: some View{
        if list.isEmpty{
            VStack(alignment: .center){
                Text("You currently have no \(empty) sessions")
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            
        }
        ForEach(list){ session in
            let tutor_detail = sessionModel.tutors.first(where: {$0.id == session.tutor_uid})!
            SessionRowView(details: session,tutor_detail: tutor_detail)
        }.padding(.horizontal, 5.0)
    }
}
