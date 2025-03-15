//
//  SelectActivityView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 15.03.2025.
//

import SwiftUI

struct SelectActivityView: View {
    @Binding var currentColorIndex: Int
    @Binding var currentActivity: String
    var currentColor: Color {
        mainColors[currentColorIndex]
    }
    var nextIndenx: Int {
        (currentColorIndex + 1) % mainColors.count
    }
    
    
    var body: some View {
        HStack(spacing: 10) {
            ScrollView(.horizontal,showsIndicators: false) {
                HStack {
                    ForEach(activities, id: \.self) { activity in
                        let isSelectedActivity = activity == currentActivity
                        Image(systemName: activity)
                            .font(isSelectedActivity ? .title2 : .subheadline)
                            .foregroundColor(isSelectedActivity ? currentColor : myNickel)
                            .opacity(isSelectedActivity ? 1.0 : 0.7)
                            .onTapGesture {
                                withAnimation {
                                    currentActivity = activity
                                    currentColorIndex = nextIndenx
                                }
                            }
                        
                    }
                }
            }
            
            Circle()
                .fill(currentColor)
                .frame(width: 20, height: 20)
                .shadow(color: currentColor.opacity(0.7), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 3)
                )
                .onTapGesture {
                    withAnimation {
                        currentColorIndex = nextIndenx

                    }
                }
        }
        
    }
}

#Preview {
    SelectActivityView(currentColorIndex: .constant(0), currentActivity: .constant(activities[0]))
        .padding(.horizontal)
}
