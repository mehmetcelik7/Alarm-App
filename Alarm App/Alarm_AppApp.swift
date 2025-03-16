//
//  Alarm_AppApp.swift
//  Alarm App
//
//  Created by mehmet Çelik on 12.03.2025.
//

import SwiftUI

@main
struct Alarm_AppApp: App {
    @StateObject var lnManager: LocalNotificationManager = LocalNotificationManager()
    var body: some Scene {
        WindowGroup {
            MainAlarmView()
                .environmentObject(lnManager)
//            MainAlarmView()
//            AboutView()
        }
    }
}
