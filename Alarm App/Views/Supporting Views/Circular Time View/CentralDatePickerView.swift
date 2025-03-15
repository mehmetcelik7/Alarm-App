//
//  CentralDatePickerView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 15.03.2025.
//

import SwiftUI

struct CentralDatePickerView: View {
    let size: CGFloat
    @Binding var alarmModel: AlarmModel
    var lineWidth : CGFloat = 10.0
  

    var body: some View {
        Circle()
            .stroke(.black.opacity(0.2),lineWidth: lineWidth)
            .frame(width: size,height: size)
            .overlay(
                VStack{
                    VStack{
                        GrayedTextView(text: "start",font: .caption)
                        TimePicker(time: $alarmModel.start.animation(), scale: 1)
                        
                    }
                    Spacer()
                    GrayedTextView(text: "Set the alarm")
                    Spacer()
                    VStack {
                       
                        TimePicker(time: $alarmModel.end.animation(), scale: 1)
                        GrayedTextView(text: "end",font: .caption)
                        
                    }
                }
                    .padding()
                    .padding(.vertical)
            )
    }
}

#Preview {
    CentralDatePickerView(size: 200, alarmModel: .constant(AlarmModel.DefaultAlarm()))
}
