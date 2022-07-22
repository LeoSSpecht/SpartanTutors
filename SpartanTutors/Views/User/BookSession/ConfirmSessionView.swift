//
//  ConfirmSessionView.swift
//  SpartanTutors
//
//  Created by Leo on 6/23/22.
//

import SwiftUI

struct ConfirmSessionView: View {
    @EnvironmentObject var bookViewModel: bookStudentSession
    @Binding var show_confirm: Bool
    @State var show_payment = false
    //STORE THE CURRENT SESSION SELECTION IN A SESSION OBJECT
    var body: some View {
        VStack{
            Spacer()
                .frame(maxHeight: 50)
            Text("Would you like to confirm this session?")
                .bold()
            Spacer()
            VStack{
                Text("Date: \(bookViewModel.dateSelection.to_WeekDay_date())")
                Text("Time: \(bookViewModel.sessionSelections?.timeframe.get_start_end_time() ?? "No session selected")")
                Text("Tutor: \(bookViewModel.sessionSelections?.tutor_name ?? "No session selected")")
                Text("Class: \(bookViewModel.selectedClass)")
                Text("Duration: 2h")
                Text("Total price: $55")
                    .bold()
            }
            
            Spacer()
            NavigationLink(
                destination: makePaymentView(payment_active:$show_confirm),isActive: $show_payment){
            }
            .isDetailLink(false)
            
            Button(action: {
                bookViewModel.createSessionObject()
                show_payment.toggle()
            }){
                Text("Confirm")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemIndigo))
                    .cornerRadius(12)
                    .padding()
            }
            
        }
        .padding()
        
    }
}

//struct ConfirmSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmSessionView()
//    }
//}
