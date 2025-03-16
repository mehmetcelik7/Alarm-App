//
//  ToBedWakeUpView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import SwiftUI

struct ToBedWakeUpView: View {
    let currentAlarmIndex: Int?
    @State var alarmModel: AlarmModel
    
    var body: some View {
        NavigationStack {
            VStack {
                
                CancelSaveAlarm(currentAlarmIndex: currentAlarmIndex, alarmModel: $alarmModel)
                
                Text("Toggle Alarm")
                AlarmToggleView(alarmEnabled: $alarmModel.alarmEnabled)
                
                Divider()
                
                HStack {
                    Grid {
                        GridRow {
                            TimeOfDayIcon(date: alarmModel.start)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                GrayedTextView(text: "start")
                                
                                TimePicker(time: $alarmModel.start, scale: 1.3)
                            }
                        }
                        
                        GridRow {
                            HStack {
                                Divider()
                                    .frame(height: 30)
                                    .padding(2)
                                
                            }
                        }
                        GridRow {
                            Image(systemName: alarmModel.activity)
                                .foregroundColor(alarmModel.activityColor)
                                .font(.headline)
                            
                            SelectActivityView(currentColorIndex: $alarmModel.colorIndex, currentActivity: $alarmModel.activity)
                            
                        }
                        .padding(.vertical)
                        
                        GridRow {
                            HStack {
                                Divider()
                                    .frame(height: 30)
                                    .padding(2)
                            }
                        }
                        GridRow {
                            TimeOfDayIcon(date: alarmModel.end)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                TimePicker(time: $alarmModel.end, scale: 1.3)
                                GrayedTextView(text: "end")
                                
                            }
                            
                        }
                        
                        GridRow {
                            Text("")
                            
                            SoundMenuViewFromButton(alarmModel: $alarmModel)
                            
                            
                            
                            
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .padding()
            .background(cardBackgroundColor.cornerRadius(20))
            .padding()
        }
    }
}

#Preview {
    ToBedWakeUpView(currentAlarmIndex: nil, alarmModel: .DefaultAlarm())
}
