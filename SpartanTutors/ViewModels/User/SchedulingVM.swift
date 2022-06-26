//
//  userViewModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/16/22.
//

import Foundation
import SwiftUI
class SessionsVM: ObservableObject{
    @Published private (set) var connection:sessionScheduler
    var student_id: String
//     var student_sessions:Array<Session>
    
    init(id: String){
        student_id = id
        connection = sessionScheduler(uid: id)
    }
    
    var sessions:Array<Session> {
        connection.studentSessions
    }
    func printSessions() -> Array<Session>{
        return connection.studentSessions
    }
    
    func book(session: Session){
//        var result = connection.bookSession(session)
        connection.retrieveStudentSessions()
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
