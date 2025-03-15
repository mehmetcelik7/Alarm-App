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
    var endTime: Date {
        alarmModel.end
    }
    var startTime: Date {
        alarmModel.start
    }
    var percentDifference: CGFloat {
        let value = dateToPercent(date: endTime) - dateToPercent(date: startTime)

        return value >= 0 ? value : 1 + value
    }
    
    var startDateToPercent: CGFloat {
        dateToPercent(date: startTime)
    }
    var endDateToPercent: CGFloat {
        startDateToPercent + percentDifference
        
    }
    
    var rotateCircleOffset: CGFloat {
         360 * startDateToPercent
    }
    
    var body: some View {
        ZStack {
            CentralDatePickerView(size: size, alarmModel: $alarmModel)
            
            TimeArcView(
                percentDifference: percentDifference,
                strokeStyle: StrokeStyle(lineWidth: 15,dash: [5,2]),
                size: size,
                rotateCircleOffset: rotateCircleOffset,
                color: .black)
            //Progressioon gray ticks
            DisplayIconOnCircularTimeView(time: startTime, size: size, percent: startDateToPercent)
            DisplayIconOnCircularTimeView(time: endTime, size: size, percent: endDateToPercent)
        }
    }
}

#Preview {
    
   
    VStack(spacing: 50){
        CircularTimeView(currentAlarmIndex: nil, alarmModel: .DefaultAlarm(), size: screenWidth / 2)
            
    }
}
