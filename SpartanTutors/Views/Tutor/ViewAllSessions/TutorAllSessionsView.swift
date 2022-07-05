//
//  TutorAllSessionsView.swift
//  SpartanTutors
//
//  Created by Leo on 6/30/22.
//

import SwiftUI

struct allSessionsTutor: View {
//    Change this to environmentObject
//    @ObservedObject var sessionModel: AdminAllSessions
    var sessions: Array<Session>
    var names: [String:String]
    
    init(sessions: Array<Session>, names: [String:String]){
        
        self.sessions = sessions
        self.names = names
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {

        let confirmed = sessions.filter{ session in
            session.status == "Approved"
        }
        let confirmed_sorted = confirmed.sorted{
            $0.date > $1.date
        }
        
        ScrollView{
            Text("Upcoming sessions")
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
            ForEach(confirmed_sorted){ session in
                TutorRowView(sessionDetail: session, student_name: names[session.student_uid]!)
            }.padding(.horizontal, 5.0)
        }
        
      
    }
}
