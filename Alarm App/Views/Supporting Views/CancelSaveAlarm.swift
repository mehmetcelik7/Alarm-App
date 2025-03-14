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
    var body: some View {
        HStack {
           
            Button(action: {
                print("Cancel")
            }, label: {
                Text("Cancel")
            })
            Spacer()
            
             Button(action: {
                 print("save")
                 if let currentAlarmIndex = currentAlarmIndex {
                     //TODO: edit alarm to view
                     
                     print("\(currentAlarmIndex)")
                 }else{
                     //TODO: Append alarm to viw mode
                     
                 }
             }, label: {
                 Text("Save")
             })
        }
    }
}

#Preview {
    CancelSaveAlarm(currentAlarmIndex: nil, alarmModel: .constant(.DefaultAlarm()))
}
