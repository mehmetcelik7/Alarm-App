//
//  TimeOfDayIcon.swift
//  Alarm App
//
//  Created by mehmet Çelik on 13.03.2025.
//

import SwiftUI

struct TimeOfDayIcon: View {
    let date: Date
    var percent: CGFloat {
        return dateToPercent(date: date)
    }
    
    var body: some View {
        Text("99")
    }
}

#Preview {
    TimeOfDayIcon()
}
