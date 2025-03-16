//
//  SoundMenuView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 16.03.2025.
//

import SwiftUI

struct SoundMenuView: View {
    @Binding var alarmSound: Sounds
    var body: some View {
        Form {
            Section(header: Text("Ringtone Sounds")) {
                ForEach(ringToneSoundsList, id: \.self) { sound in
                  
                    Button(action: {
                        alarmSound = sound
                        playSound(sound: sound.rawValue)
                    }, label: {
                        HStack {
                            Image(systemName:"checkmark")
                                .foregroundColor(.cyan)
                                .fontWeight(.semibold)
                                .opacity(alarmSound == sound ? 1.0 : 0.3)

                            Text(sound.rawValue.formatSoundName)
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        }
                    })
                }
            }
            
            Section(header: Text("Sounds of Nature")) {
                ForEach(natureSoundsList, id: \.self) { sound in
                    Button(action: {
                        alarmSound = sound
                        playSound(sound: sound.rawValue)
                    }, label: {
                        HStack {
                            Image(systemName:"checkmark")
                                .foregroundColor(.cyan)
                                .fontWeight(.semibold)
                                .opacity(alarmSound == sound ? 1.0 : 0.3)

                            Text(sound.rawValue.formatSoundName)
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        }
                    })
                }
            }

        }
    }
}

#Preview {
    SoundMenuView(alarmSound: .constant(AlarmModel.DefaultAlarm().sound))
}
