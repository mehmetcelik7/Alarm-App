//
//  AddEditAlarmView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import SwiftUI

struct AddEditAlarmView: View {
    let currentAlarmIndex: Int?
    @State var alarmModel: AlarmModel
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
                
                ToBedWakeUpView(currentAlarmIndex: currentAlarmIndex, alarmModel: alarmModel)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                withAnimation {
                    showYouDidItView = false
                }
           }
        }
    }
}

#Preview {
    AddEditAlarmView(currentAlarmIndex: nil, alarmModel: .DefaultAlarm())
}
