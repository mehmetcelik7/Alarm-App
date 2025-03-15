//
//  ContentView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 12.03.2025.
//

import SwiftUI

struct MainAlarmView: View {
    var body: some View {
        
        TabView {
            AddEditAlarmView(currentAlarmIndex: nil, alarmModel: .DefaultAlarm())
                .tabItem( {
                    Label("Alarms", systemImage: "alarm.fill")
                })
            
            AboutView()
                .tabItem({
                    Label("About", systemImage: "info.circle.fill")
                })
            
        }
    }
}

#Preview {
    MainAlarmView()
}
