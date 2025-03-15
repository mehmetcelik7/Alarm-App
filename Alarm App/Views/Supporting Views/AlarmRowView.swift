//
//  AlarmRowView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 15.03.2025.
//

import SwiftUI

struct AlarmRowView: View {
    let model : AlarmModel
    let i: Int
    var body: some View {
        
        HStack {
            Image(systemName: model.activity)
                .foregroundColor(model.activityColor)
                .font(.title)
            
           
                Text("\(getTimeFromDate(date: model.end))")
                    .font(.title)
                    .fontWeight(model.alarmEnabled ? .regular : .thin)
                    .scaleEffect(model.alarmEnabled ? 1.05: 1.0)
                    .opacity(model.alarmEnabled ? 1.0 : 0.7)
            
            Spacer()
            // Todo changed later
            let alarmViewModels = AlarmModel.DummyAlarmData()
            TheToggleView(isOn: .constant(alarmViewModels[i].alarmEnabled))
        }
    }
}

#Preview {
    AlarmRowView(model: .DefaultAlarm(), i: 0)
}
