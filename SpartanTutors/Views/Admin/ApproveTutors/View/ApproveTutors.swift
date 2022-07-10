//
//  ApproveTutors.swift
//  SpartanTutors
//
//  Created by Leo on 7/5/22.
//

import SwiftUI

struct ApproveTutors: View {
    @ObservedObject var AllTutors: ApproveTutorViewModel
    var body: some View {
        ScrollView{
            ForEach(AllTutors.unapproved_tutors){tutor in
                ApproveTutorRow(tutor:tutor,approve_function: AllTutors.approveTutor)
                    .aspectRatio(3,contentMode: .fill)
                    .padding([.top, .leading, .trailing],6)
//                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            }
        }
    }
}
//
//struct ApproveTutors_Previews: PreviewProvider {
//    static var previews: some View {
//        ApproveTutors(tutors: ["Leo","Chris","Tutor 1"])
//    }
//}
