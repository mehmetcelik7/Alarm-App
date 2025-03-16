//
//  ContentView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 12.03.2025.
//

import SwiftUI

struct MainAlarmView: View {
    @EnvironmentObject var lnManager: LocalNotificationManager
    
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        
        TabView {

            if lnManager.isAuthorized {
              ListOfTheAlarmsView()
                    .tabItem( {
                        Label("Alarms", systemImage: "alarm.fill")
                    })
                
                AboutView()
                    .tabItem({
                        Label("About", systemImage: "info.circle.fill")
                    })
            }else{
                EnableNotifications()
            }
            
        }
        .ignoresSafeArea()
        .task {
            try? await lnManager.requestAuthorization()
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                Task {
                    
                    await lnManager.getCurrentSettings()
                    await lnManager.getPendingAlarms()
                }
            }
        }
    }
}

#Preview {
    MainAlarmView()
}
