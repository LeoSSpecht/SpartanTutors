//
//  makePaymentView.swift
//  SpartanTutors
//
//  Created by Leo on 6/26/22.
//

import SwiftUI

struct makePaymentView: View {
    @Binding var payment_active: Bool
    @EnvironmentObject var tab_vm: tab_selection
    var body: some View {
        VStack{
            Text("Awesome, your sesion was booked and is now pending. Once we confirm your session you will see it as confirmed")
            Link("Go to Venmo",
                  destination: URL(string: "https://venmo.com/code?user_id=3452041510782782609&created=1657753854.0826159&printed=1")!)
            Button(action: {
                print("See sessions")
                tab_vm.selection = 2
                payment_active.toggle()
                
            }) {
                Text("See my sessions")
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
