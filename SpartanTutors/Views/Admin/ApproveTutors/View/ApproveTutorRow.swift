//
//  ApproveTutorRow.swift
//  SpartanTutors
//
//  Created by Leo on 7/5/22.
//

import SwiftUI

struct ApproveTutorRow: View {
    var tutor:Tutor
    var approve_function: (String) -> Void
    var scale_size:CGFloat = 1.5
    var body: some View {
        let img_size:CGFloat = 30
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .shadow(radius: 3)
            HStack{
                Text(tutor.name)
                    .fontWeight(.bold)
                Spacer().frame(maxWidth: .infinity)
                
//                symbol(
//                    name: "xmark.circle.fill",
//                    img_size: img_size,
//                    color:Color(red: 0.8, green: 0.3, blue: 0.3))
                Spacer()
                symbol(
                    name: "checkmark.circle.fill",
                    img_size: img_size,
                    color:Color(red: 0.3, green: 0.6, blue: 0.3))
                    .onTapGesture {
                        approve_function(tutor.id)
                    }
                    
            }.padding()
        }
        
       
    }
}

struct symbol:View{
    var name:String
    var img_size:CGFloat
    var color:Color
    var body: some View{
        Image(systemName: name)
            .resizable()
            .foregroundColor(color)
            .aspectRatio(1,contentMode: .fill)
            .frame(width: img_size, height: img_size,alignment: .center)
    }
}
//
//struct ApproveTutorRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ApproveTutorRow()
//    }
//}
