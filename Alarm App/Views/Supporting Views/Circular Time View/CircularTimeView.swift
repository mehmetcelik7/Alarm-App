//
//  CircularTimeView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 15.03.2025.
//

import SwiftUI

struct CircularTimeView: View {
    
    let currentAlarmIndex: Int?
    
    @State var alarmModel: AlarmModel
    
    let size: CGFloat
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 20)
            .frame(width: size)
            .overlay(
                Text("Circular Alarm")
            )
    }
}

#Preview {
    
   
    VStack(spacing: 50){
        CircularTimeView(currentAlarmIndex: nil, alarmModel: .DefaultAlarm(), size: screenWidth / 2)
        //            CircularTimeView(currentAlarmIndex: nil, alarmModel: .DefaultAlarm(), size: screenWidth / 4)
        //            CircularTimeView(currentAlarmIndex: nil, alarmModel: .DefaultAlarm(), size: screenWidth / 0.75)
        //        }
        
    }
}
