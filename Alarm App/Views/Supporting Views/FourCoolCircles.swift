//
//  FourCoolCircles.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import SwiftUI

struct CoolCircleView: View {
    
    let radius: CGFloat
    var color1 = myYellow
    var color2 = Color.clear
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(colors: [color1,color2], startPoint: .top, endPoint: .bottom)
            )
            .frame(width: radius,height: radius)
    }
}

struct FourCoolCircles: View {
    
    var color1 = myDarkYellow
    var color2 = myLightYellow
    
    @State private var offsetX: [CGFloat] = [
        0,0,0,0
    ]
    @State private var offsetY: [CGFloat] = [
        0,0,0,0
    ]
    
    @State private var time = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    
    var body: some View {
        Text("99 like icardi")
    }
}

#Preview {
    FourCoolCircles()
}
