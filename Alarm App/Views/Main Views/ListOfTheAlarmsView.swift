//
//  ListOfTheAlarmsView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 15.03.2025.
//

import SwiftUI

struct ListOfTheAlarmsView: View {
//    var alarmViewModels: [AlarmModel]
    
    @EnvironmentObject var lnManager: LocalNotificationManager
    @State var isActive = false
    @State var currentIndex : Int? = nil
    
    
    var body: some View {
      
        NavigationStack {
            ZStack {
                List {
                    ForEach(lnManager.alarmViewModels.indices, id: \.self
                    ) { i in
                       
                        Button(action: {
                            currentIndex = i
                            isActive.toggle()
                        }, label: {
                            AlarmRowView(model: lnManager.alarmViewModels[i], i: i)
                                .padding(.vertical)
                        })
                       
                    }
                    .onDelete(perform: deleteMe)
                }
                FourCoolCircles()
                    .opacity(0.3)
             
            }
            .navigationTitle("Alarm List")
            .sheet(isPresented: $isActive,onDismiss: {}) {
                
                
                wrapAddEditAlarmView(currentAlarmIndex: $currentIndex)
            }
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Button(action: {
                          
                            isActive.toggle()
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
    func deleteMe(ofsetts: IndexSet)  {
        for index in ofsetts {
           
            print("Remove request from \(lnManager.alarmViewModels[index].id)")
            lnManager.removeRequest(id: lnManager.alarmViewModels[index].id)
        }
        
        lnManager.alarmViewModels.remove(atOffsets: ofsetts)
        
    }
}

struct wrapAddEditAlarmView: View {
    @EnvironmentObject var lnManager: LocalNotificationManager
    @Binding var currentAlarmIndex: Int?
    var body: some View {
       
        if let  currentAlarmIndex = currentAlarmIndex {
            AddEditAlarmView(currentAlarmIndex: currentAlarmIndex, alarmModel: lnManager.alarmViewModels[currentAlarmIndex])

        }else{
            AddEditAlarmView(currentAlarmIndex: currentAlarmIndex, alarmModel: .DefaultAlarm())

        }
       
    }
}

#Preview {
    ListOfTheAlarmsView()
        .environmentObject(LocalNotificationManager())
}
