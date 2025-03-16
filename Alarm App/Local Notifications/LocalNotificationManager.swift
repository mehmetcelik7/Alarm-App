//
//  LocalNotificationsManager.swift
//  Alarm App
//
//  Created by mehmet Çelik on 15.03.2025.
//

import Foundation
import NotificationCenter

@MainActor
class LocalNotificationManager:NSObject,ObservableObject,UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var isAuthorized = false
    
    @Published var pendingAlarms: [UNNotificationRequest] = []
    
    @Published var alarmViewModels: [AlarmModel] = [] {
        didSet {
//            saveItem()
        }
    }
    
    let itemKey = "Alarm List"
    
    
    
    func requestAuthorization() async throws {
        try await notificationCenter.requestAuthorization(options: [
            .sound, .badge, .alert
        ])
        
        await getCurrentSettings()
    }
    
    func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        
        isAuthorized = currentSettings.authorizationStatus == .authorized
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }

    func saveItems () {
        if let encodeData = try? JSONEncoder()
            .encode(alarmViewModels) {
            UserDefaults
                .standard
                .set(encodeData, forKey: itemKey)
            }
    }
    
    override init() {
        super.init()
        
        guard let data = UserDefaults.standard.data(forKey: itemKey),
                let savedItems = try? JSONDecoder().decode([AlarmModel].self, from: data)
        else {
            return
            
        }
        self.alarmViewModels = savedItems
    }
    func getPendingAlarms() async {
        pendingAlarms = await notificationCenter
            .pendingNotificationRequests()
    }
    
    func schedule(localNotification: AlarmModel) async {
        let content = UNMutableNotificationContent()
        content
            .body = NSLocalizedString(localNotification.body, comment: "")
        content
            .sound = customSound(soundName: localNotification.sound)
        
    }
    func customSound(soundName: Sounds,fileExtension: String = "") -> UNNotificationSound? {
        
        let period = fileExtension.isEmpty ? "" : ".\(fileExtension)"
        let filename = "\(soundName.rawValue)\(period)\(fileExtension)"
     
        return UNNotificationSound(named: UNNotificationSoundName(rawValue: filename))
    }
    
}

