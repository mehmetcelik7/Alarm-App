//
//  SelectActivityViewExpanded.swift
//  Alarm App
//
//  Created by mehmet Çelik on 15.03.2025.
//

import SwiftUI

struct SelectActivityViewExpanded: View {
    @Binding var currentColorIndex: Int
    @Binding var currentActivity: String
    var circleFrame = 20.0
    var body: some View {
        HStack(spacing: 30) {
            
            ForEach(0..<mainColors.count,id: \.self) { i in
                let color = mainColors[i]
                let isSelectedColor = color == mainColors[currentColorIndex] // crash yersen burası hatalı olabilir TODO:
               
                Circle()
                    .fill(color)
                    .frame(width: circleFrame,height: circleFrame)
                    .shadow(color:color.opacity(0.7),radius: 10, x:0, y: 5)
                    .scaleEffect(isSelectedColor ? 1.1: 1.0)
                    .overlay(
                        Circle()
                            .stroke(lineWidth: isSelectedColor ? 3 : 0.3)
                    )
                    .onTapGesture {
                        withAnimation {
                            currentColorIndex = i
                        }
                    }
            }
        }
    }
}

#Preview {
    SelectActivityViewExpanded(currentColorIndex: .constant(0), currentActivity: .constant(activities[0]))
        .padding(.horizontal)
}
