//
//  AlarmToggleView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import SwiftUI

struct AlarmToggleView: View {
    @Binding var alarmEnabled: Bool
    
    var body: some View {
        HStack {
            GrayedTextView(text: "alarm")
            Spacer()
            TheToggleView(isOn: $alarmEnabled)
        }
        .padding()
    }
}

#Preview {
    VStack {
        AlarmToggleView(alarmEnabled: .constant(true))

        AlarmToggleView(alarmEnabled: .constant(true))
    }
}
