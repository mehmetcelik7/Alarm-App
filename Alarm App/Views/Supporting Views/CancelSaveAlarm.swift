//
//  CancelSaveAlarm.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import SwiftUI

struct CancelSaveAlarm: View {
    let currentAlarmIndex: Int?
    @Binding var alarmModel: AlarmModel
    
    @EnvironmentObject var lnManager: LocalNotificationManager
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        HStack {
           
            Button(action: {
                
                self.presentation
                    .wrappedValue
                    .dismiss()
                
            }, label: {
                Text("Cancel")
            })
            Spacer()
            
             Button(action: {
              
                 if let currentAlarmIndex = currentAlarmIndex {
                   
                     
                     
                     lnManager.alarmViewModels[currentAlarmIndex] = alarmModel
                     
                 }else{
                     lnManager.safeAppend(localNotification: alarmModel)
                     
                 }
                 
                 Task {
                     if alarmModel.alarmEnabled {
                         await lnManager.schedule(localNotification: alarmModel)
                     }else{
                         lnManager.removeRequest(id: alarmModel.id)
                     }
                 }
                 
                 self.presentation
                     .wrappedValue
                     .dismiss()
             }, label: {
                 Text("Save")
             })
        }
    }
}

#Preview {
    CancelSaveAlarm(currentAlarmIndex: nil, alarmModel: .constant(.DefaultAlarm()))
        .environmentObject(LocalNotificationManager())
}
