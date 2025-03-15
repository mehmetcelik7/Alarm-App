//
//  EnableNotifications.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import SwiftUI

struct EnableNotifications: View {
    @EnvironmentObject var lnManager: LocalNotificationManager
    
    
    var body: some View {
        ZStack {
            FourCoolCircles()
            VStack {
                Spacer()
                CoolTextView(text: LocalizedStringKey("Enable notifications , icardi"), size: 48)
                    .multilineTextAlignment(.center)
                Spacer()
                
                Button(action: {
                    lnManager.openSettings()
                }, label: {
                 
                    ButtonView(text: "enable")
                        .padding()
                })
            }
        }
    }
}

#Preview {
    EnableNotifications()
        .environmentObject(LocalNotificationManager())
}
