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
    @State var currentIndex : Int?
//    @State var addEditViewType: AddEditViewType = .standart
    @State var addEditViewType: AddEditViewType = .circular
    
    var body: some View {
      
        NavigationStack {
            ZStack {
                List {
                    ForEach(lnManager.alarmViewModels.indices, id: \.self
                    ) { i in
                       
                        
                        AlarmRowViewButton(model: lnManager.alarmViewModels[i], i: i,currentIndex: $currentIndex, isActive: $isActive)
                            .padding(.vertical)
                       
                    }
                    .onDelete(perform: deleteMe)
                }
                FourCoolCircles()
                    .opacity(0.3)
             
            }
            .navigationTitle("Alarm List")
            .sheet(isPresented: $isActive,onDismiss: {}) {
                
                
                ChooseAlarmView(currentAlarmIndex: $currentIndex, addEditViewType: addEditViewType)
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


#Preview {
    ListOfTheAlarmsView()
        .environmentObject(LocalNotificationManager())
}
