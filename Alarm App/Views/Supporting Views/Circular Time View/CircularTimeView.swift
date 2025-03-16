//
//  CircularTimeView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 15.03.2025.
//

import SwiftUI

struct CircularTimeView: View {
    let currentAlarmIndex: Int?
    @Binding var alarmModel: AlarmModel
    
    let size: CGFloat
    
    var startTime: Date {
        alarmModel.start
    }
    var endTime: Date {
        alarmModel.end
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
            CentralDatePickerView(size: size,
            alarmModel: $alarmModel
            )
            
            // Progression - black curve
            TimeArcView(
                percentDifference: percentDifference,
                strokeStyle: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round),
                size: size,
                rotateCircleOffset: rotateCircleOffset,
                color: .black)
            
            // Progression - Gray ticks
            TimeArcView(
                percentDifference: percentDifference,
                strokeStyle: StrokeStyle(lineWidth: 15,
                        dash: [1,2]),
                size: size,
                rotateCircleOffset: rotateCircleOffset,
                color: .gray)
            
            // First icon
            DisplayIconOnCircularTimeView(
                time: startTime,
                size: size,
                percent: startDateToPercent)
            
            // Second icon
            DisplayIconOnCircularTimeView(
                time: endTime,
                size: size,
                percent: endDateToPercent)
        }
    }
}

#Preview {
    
   
    VStack(spacing: 50) {
        CircularTimeView(currentAlarmIndex: nil, alarmModel: .constant(.DefaultAlarm()), size: screenWidth / 2)
    }
}
