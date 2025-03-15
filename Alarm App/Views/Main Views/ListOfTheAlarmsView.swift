//
//  ListOfTheAlarmsView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 15.03.2025.
//

import SwiftUI

struct ListOfTheAlarmsView: View {
    var alarmViewModels: [AlarmModel]
    var body: some View {
      
        NavigationStack {
            ZStack {
                List {
                    ForEach(0..<alarmViewModels.count, id: \.self
                    ) { i in
                        let alarmModel = alarmViewModels[i]
                        NavigationLink(destination: {
                            
                            AddEditAlarmView(currentAlarmIndex: i, alarmModel: alarmModel)
                        }, label: {
                           
                                AlarmRowView(model: alarmModel, i: i)
                            
                        })
                    }
                }
                FourCoolCircles()
                    .opacity(0.3)
             
            }
            .navigationTitle("Alarm List")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: {
                            
                            AddEditAlarmView(currentAlarmIndex: nil, alarmModel: .DefaultAlarm())
                        }, label: {
                            Text("+")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .foregroundColor(myBlack)
                        })
                        
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    
                }
        }
    }
}

#Preview {
    ListOfTheAlarmsView(alarmViewModels: AlarmModel.DummyAlarmData())
}
