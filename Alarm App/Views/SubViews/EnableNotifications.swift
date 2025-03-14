//
//  EnableNotifications.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import SwiftUI

struct EnableNotifications: View {
    var body: some View {
        ZStack {
            FourCoolCircles()
            VStack {
                Spacer()
                CoolTextView(text: LocalizedStringKey("Enable notifications , icardi"), size: 48)
                    .multilineTextAlignment(.center)
                Spacer()
                
                Button(action: {
                    print("TODO: like icardi")
                }, label: {
                    Text("enable")
                })
            }
        }
    }
}

#Preview {
    EnableNotifications()
}
