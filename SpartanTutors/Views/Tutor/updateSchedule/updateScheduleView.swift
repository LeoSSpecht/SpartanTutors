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
    @StateObject var calendarViewModel = calendarVM()
    
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
            
            CalendarView(calendarViewModel: calendarViewModel,selected_date: $UpdateScheduleViewModel.date).padding(0)
            
            ScrollView{
                ForEach(UpdateScheduleViewModel.schedule!.data.indices){ ind in
                    HStack{
                        space
                        ZStack{
                            RoundedRectangle(cornerRadius:3)
                                .stroke(lineWidth: 3)
                                .fill(getColor(value: UpdateScheduleViewModel.schedule!.data[ind]))
                                .foregroundColor(.white)
                            Text("\(Timeframe.get_time_from_frame(ind: ind)) - \(Timeframe.get_time_from_frame(ind: ind+1))")
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
        .popup(isPresented: $UpdateScheduleViewModel.showInvalidPopUp, type: .toast, position: .top, autohideIn: 1.8) { // 3
            PopUpBody(text: "You need to select at least \(TimeConstants.units_in_session) blocks, for 2 hour sessions", color: Color(red: 1, green: 0.8, blue: 0.8))
        }
        .popup(isPresented: $UpdateScheduleViewModel.showWorkedPopUp, type: .toast, position: .top, autohideIn: 2) { // 3
            PopUpBody(text: "Updated schedule for \(UpdateScheduleViewModel.date.to_WeekDay_date())", color: Color(red: 0.8, green: 1, blue: 0.8))
        }
        .popup(isPresented: $UpdateScheduleViewModel.showErrorPopUp, type: .toast, position: .top, autohideIn: 2) { // 3
            PopUpBody(text: "Sorry there was an error :(", color: Color(red: 0.8, green: 1, blue: 0.8))
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
