//
//  ConfirmSessionView.swift
//  SpartanTutors
//
//  Created by Leo on 6/23/22.
//

import SwiftUI

struct ConfirmSessionView: View {
    @ObservedObject var bookViewModel: bookStudentSession
    @State var show_payment = false
    @Binding var show_book_view:Bool
    
    var body: some View {
        VStack{
            
            
            Spacer()
                .frame(maxHeight: 50)
            Text("Would you like to confirm this session?")
                .bold()
            Spacer()
            Text("Date: \(Date_to_string(date: bookViewModel.dateSelection))")
            Text("Time: \(bookViewModel.sessionSelections?[0] ?? "") am")
            Text("Tutor: \(bookViewModel.tutorSelection.tutorName)")
            Text("Class: \(bookViewModel.classSelection)")
            Spacer()
            NavigationLink(
                destination: makePaymentView(show_book_view: $show_book_view),isActive: $show_payment){
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
    
    func Date_to_string(date: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "eee MM/dd/YY"
        let formatted = df.string(from: date)
        return formatted
    }
    
    func Date_to_time(date: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "hh:mm a 'on'"
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        let formatted = df.string(from: date)
        return formatted
    }
}

//struct ConfirmSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmSessionView()
//    }
//}
