//
//  AddEditAlarmView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import SwiftUI

struct AddEditAlarmView: View {
    let currentAlarmIndex: Int?
//    @State var alarmModel: AlarmModel = .DefaultAlarm()
    @EnvironmentObject var lnManager: LocalNotificationManager
    @State private var showYouDidItView = true
    var body: some View {
        ZStack {
            backgroundColor
                .opacity(0.7)
                .ignoresSafeArea()
            VStack {
                if showYouDidItView {
                    YouDidItView()
                }
                if let  currentAlarmIndex = currentAlarmIndex {
                    ToBedWakeUpView(currentAlarmIndex: currentAlarmIndex, alarmModel: lnManager.alarmViewModels[currentAlarmIndex])
                }else{
                    ToBedWakeUpView(currentAlarmIndex: currentAlarmIndex, alarmModel: .DefaultAlarm())
                }
               
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                withAnimation {
                    showYouDidItView = false
                }
           }
        }
    }
}

#Preview {
    AddEditAlarmView(currentAlarmIndex: nil)
        .environmentObject(LocalNotificationManager())
}
