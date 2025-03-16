//
//  SelectView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 16.03.2025.
//

import SwiftUI

struct SelectView: View {
    let width: CGFloat
    @Binding var addEditViewType: AddEditViewType
    @Binding var isActive: Bool
    var isStandardView: Bool {
        addEditViewType == .standart
    }
    var isCircularView: Bool {
       
        !isStandardView
    }
    var body: some View {
        HStack {
            
            Button(action: {
                withAnimation {
                    addEditViewType = .standart
                    isActive = true
                }
                
            }, label: {
                ImageDisplayView(name: standartViewImage, width: 50)
                    .scaleEffect(isStandardView ? 1.05 : 1.0)
                    .shadow(color: .blue, radius: isStandardView ? 5 : 0 , x: 0, y: 0)
            })
            
            Spacer()
            Button(action: {
                withAnimation {
                    addEditViewType = .circular
                    isActive = true
                }
                
            }, label: {
                ImageDisplayView(name: circularViewImage, width: 50)
                    .scaleEffect(isCircularView ? 1.05 : 1.0)
                    .shadow(color: .blue, radius: isCircularView ? 5 : 0 , x: 0, y: 0)
            })
        }
        .padding()
    }
}

#Preview {
    VStack {
        SelectView(width: 50, addEditViewType: .constant(.standart), isActive: .constant(true))
        
    }
}
