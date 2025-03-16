//
//  MainAddEditAlarmView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 15.03.2025.
//

import SwiftUI

struct MainAddEditAlarmView: View {
    let currentAlarmIndex: Int?
    @State var alarmModel: AlarmModel
    @State private var selectedTab = "One"
    var body: some View {
        TabView(selection: $selectedTab) {
            AddEditAlarmView(currentAlarmIndex: currentAlarmIndex, alarmModel: alarmModel)
                .tag("One")
                
            AddEditCircularAlarmView(currentAlarmIndex: currentAlarmIndex, alarmModel: alarmModel)
                .tag("Two")
          
            
        }
        .onAppear{
            UIPageControl
                .appearance()
                .currentPageIndicatorTintColor = .blue
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .ignoresSafeArea()
    }
}

#Preview {
    MainAddEditAlarmView(currentAlarmIndex: nil, alarmModel: .DefaultAlarm())
      
}
