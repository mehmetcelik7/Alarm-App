//
//  MainGradient.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import SwiftUI

struct MainGradient: View {
    
    var startRadius: CGFloat = 0
    let endRadius: CGFloat
    var scaleX = 2.0
    var opacityLinGrad = 0.5
    var opacityRadGrad = 1.0
    var yellowColor = myYellow
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [
                myBlue,myPink,myPurple
            ], startPoint: .top, endPoint: .bottom)
            .opacity(opacityLinGrad)
            
            RadialGradient(
                colors: [myYellow,.clear],
                center: .bottom,
                startRadius: startRadius,
                endRadius: endRadius
            )
            .opacity(opacityLinGrad)
            .scaleEffect(x: scaleX)
        }
    }
}

#Preview {
    MainGradient(endRadius: 75)
        .frame(width: screenWidth, height: 100)
}
