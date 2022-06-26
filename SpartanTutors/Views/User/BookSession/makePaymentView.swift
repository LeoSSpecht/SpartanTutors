//
//  makePaymentView.swift
//  SpartanTutors
//
//  Created by Leo on 6/26/22.
//

import SwiftUI

struct makePaymentView: View {
    @Binding var show_book_view:Bool
    
    var body: some View {
        VStack{
            Text("Awesome, your sesion was booked and is now pending. Once we confirm your session you will see it as confirmed")
            Text("Payment link")
            Button(action: {
                print("go back")
                show_book_view = false
            }) {
                Text("Go back to home page")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemIndigo))
                    .cornerRadius(12)
                    .padding()
            }
        }.padding()
        .navigationBarBackButtonHidden(true)
    }
}

//struct makePaymentView_Previews: PreviewProvider {
//    static var previews: some View {
//        makePaymentView()
//    }
//}
