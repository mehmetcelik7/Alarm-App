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
            List {
                ForEach(0..<alarmViewModels.count, id: \.self
                ) { i in
                    let alarmModel = alarmViewModels[i]
                    NavigationLink(destination: {
                        Text("Data for alarm \(i)")
                    }, label: {
                        HStack {
                            Image(systemName: alarmModel.activity)
                                .foregroundColor(alarmModel.activityColor)
                            Text("Alarm Row View-edit me")
                        }
                    })
                }
            }
            .navigationTitle("Alarm List")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: {
                        Text("Create new alarm")
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
