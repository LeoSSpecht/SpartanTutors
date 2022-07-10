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
            Text("Date: \(Date_to_string(date: bookViewModel.dateSelection))")
            Text("Time: \(bookViewModel.sessionSelections!.time_string)")
            Text("Tutor: \(bookViewModel.tutorSelection.tutorName)")
            Text("Class: \(bookViewModel.selectedClass)")
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
    
    func Date_to_string(date: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "eee MM/dd/YY"
        let formatted = df.string(from: date)
        return formatted
    }
    
    func Date_to_time(date: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        let formatted = df.string(from: date)
        return formatted
    }
    
    //REPEATED FUNCTION
    func get_time_frame(time_slot:String) -> String {
        if time_slot == "Error"{return "Error"}
        let inital_time = 8
        let duration = 2
        var ind:Int = 0
        for i in time_slot{
            if i == "2"{
                break
            }
            ind += 1
        }
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        components.hour = inital_time+ind/2
        components.minute = ind%2 == 0 ? 0 : 30
        let start_time = Calendar.current.date(from: components)
        components.hour = inital_time+ind/2 + duration
        let end_time = Calendar.current.date(from: components)
        return "\(Date_to_time(date: start_time!)) - \(Date_to_time(date: end_time!))"
    }
}

//struct ConfirmSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmSessionView()
//    }
//}
