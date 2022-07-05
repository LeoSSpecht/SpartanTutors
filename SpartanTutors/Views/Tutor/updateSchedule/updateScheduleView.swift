//
//  updateScheduleView.swift
//  SpartanTutors
//
//  Created by Leo on 6/30/22.
//

import SwiftUI
import PopupView
struct updateScheduleView: View {
    @ObservedObject var UpdateScheduleViewModel:scheduleUpdateViewModel

    init(_ id:String) {
        UpdateScheduleViewModel = scheduleUpdateViewModel(id)
        
        //Hides extra space form navigation bar
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        let space = Spacer().frame(width: 50)
        VStack{
            Text("Please select your schedule")
                .font(.title3)
                .bold()
                .padding([.leading, .bottom, .trailing])
            
            DatePicker(
                "Select a date",
                selection: $UpdateScheduleViewModel.date,
                in: Date()...,
                displayedComponents: [.date]
            )
            .padding([.leading, .bottom, .trailing])
            .id(UpdateScheduleViewModel.date)
            
            ScrollView{
                ForEach(UpdateScheduleViewModel.schedule!.indices){ ind in
                    HStack{
                        space
                        ZStack{
                            RoundedRectangle(cornerRadius:3)
                                .stroke(lineWidth: 3)
                                .fill(getColor(value: UpdateScheduleViewModel.schedule![ind]))
                                .foregroundColor(.white)
                            Text("\(get_time_frame(ind: ind)) - \(get_time_frame(ind: ind+1))")
                        }.aspectRatio(contentMode: .fit)
                        space
                            
                    }
                    .onTapGesture {
                        UpdateScheduleViewModel.selectTime(ind: ind)
                    }
                }.padding(.vertical)
            }
            
            Button(action: {
                UpdateScheduleViewModel.try_to_update_schedule()
            }) {
              Text("Update times")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemIndigo))
                .cornerRadius(12)
                .padding()
            }
        }
        .popup(isPresented: $UpdateScheduleViewModel.showInvalidPopUp, type: .toast, position: .top, autohideIn: 1.8) { // 3
            PopUpBody(text: "You need to select at least 4 blocks, for 2 hour sessions", color: Color(red: 1, green: 0.8, blue: 0.8))
        }
        .popup(isPresented: $UpdateScheduleViewModel.showWorkedPopUp, type: .toast, position: .top, autohideIn: 2) { // 3
            PopUpBody(text: "Updated schedule for \(date_to_pop_string(UpdateScheduleViewModel.date))", color: Color(red: 0.8, green: 1, blue: 0.8))
        }
        .navigationBarBackButtonHidden(self.UpdateScheduleViewModel.hide_bar)
        .navigationBarTitle("",displayMode: .inline).padding(0)
        .toolbar{
            ToolbarItemGroup{
                HStack{
                    ToolBarButton(text: "Full", hidden: self.UpdateScheduleViewModel.hide_bar){
                        self.UpdateScheduleViewModel.full_schedule()
                    }
                    ToolBarButton(text: "Clear", hidden: self.UpdateScheduleViewModel.hide_bar){
                        self.UpdateScheduleViewModel.clear_schedule()
                    }
                }
            }
        }
        
    }
}

struct ToolBarButton:View{
    var text:String
    var hidden:Bool
    var action: () -> Void
    var body: some View{
        Button(action: self.action){
            Text(text)
        }
        .opacity(self.hidden ? 0: 1)
        .disabled(self.hidden)
    }
}
struct PopUpBody:View{
    var text:String
    var color:Color
    var body: some View{
        Text(text)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(EdgeInsets(top: 60, leading: 32, bottom: 16, trailing: 32))
            .frame(maxWidth: .infinity,minHeight: 119, alignment: .center)
            .background(color)
            .cornerRadius(10.0)
    }
}



// MARK: Model stuff
struct updateScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        updateScheduleView("123")
    }
}



func dateToIntStr(date: Date) -> String{
    return "\(Int((((date.timeIntervalSince1970/60)/60)/24)))"
}

func getColor(value:Int) -> Color{
    switch value {
    case 2:
        return Color.blue
    case 1:
        return Color.green
    default:
        return Color.red
    }
}

//repeated functions from sessoin object
func get_time_frame(ind: Int) -> String{
    let duration = 1
    let inital_time = 8
    var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
    components.hour = inital_time+ind/2
    components.minute = ind%2 == 0 ? 0 : 30
    let start_time = Calendar.current.date(from: components)
    return "\(date_to_time(start_time!))"
}

func date_to_time(_ date: Date) -> String{
    let df = DateFormatter()
    df.dateFormat = "hh:mm a"
    df.amSymbol = "AM"
    df.pmSymbol = "PM"
    let formatted = df.string(from: date)
    return formatted
}

func date_to_pop_string(_ date: Date) -> String{
    let df = DateFormatter()
    df.dateFormat = "eee - MM/dd/YY"
    let formatted = df.string(from: date)
    return formatted
}
