//
//  ChooseAlarmView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 16.03.2025.
//

import SwiftUI
enum AddEditViewType {
    case standart, circular
}

struct ChooseAlarmView: View {
    @Binding var currentAlarmIndex: Int?
    @EnvironmentObject var lnManager: LocalNotificationManager
    
    let addEditViewType: AddEditViewType
    
        var body: some View {
       
        if let  currentAlarmIndex = currentAlarmIndex {
            
            if addEditViewType == .standart {
                
                AddEditAlarmView(currentAlarmIndex: currentAlarmIndex, alarmModel: lnManager.alarmViewModels[currentAlarmIndex])
            }else{
              
                AddEditCircularAlarmView(currentAlarmIndex: currentAlarmIndex, alarmModel: lnManager.alarmViewModels[currentAlarmIndex])
            }
           

        }else{
            if addEditViewType == .standart {
                AddEditAlarmView(currentAlarmIndex: currentAlarmIndex, alarmModel: .DefaultAlarm())
            }else{
                AddEditCircularAlarmView(currentAlarmIndex: currentAlarmIndex, alarmModel: .DefaultAlarm())
            }
            
          

        }
       
    }
}


#Preview {
    ChooseAlarmView(currentAlarmIndex: .constant(nil), addEditViewType: .standart)

}
