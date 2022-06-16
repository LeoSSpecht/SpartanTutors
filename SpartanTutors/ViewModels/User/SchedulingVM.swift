//
//  userViewModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import Foundation
class SessionsVM: ObservableObject{
    private var connection = sessionScheduler()
    var student_id: String
    
    @Published var student_sessions:Array<Session>
    
    init(id: String){
        student_id = id
        student_sessions = connection.retrieveStudentSessions(student_uid: student_id)
    }
    
    func book(session: Session){
        var result = connection.bookSession(session)
    }
    
    func update(session_id: String, newStatus: String){
        var result = connection.changeSessionStatus(session_id: session_id, session_status: newStatus)
    }
    
    func createSessionObject(content: [String:Any]){
        var content = content
        content["student_uid"] = student_id
        let sessionToBook = Session(content)
        book(session: sessionToBook)
    }
    
}
