//
//  SplashScreenView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isACtive: Bool = true
    @State private var opacity = 0.3
    @State private var fontSize = 12.0
    
    var body: some View {
        if isACtive {
            MainAlarmView()
        }else {
            ZStack {
                FourCoolCircles(color1: myBlue, color2: .clear)
                
                VStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("99 like icardi")
                        Text("let's add an alarm")
                            
                    }
                    .multilineTextAlignment(.leading)
                    .padding()
                    .onAppear{
                        withAnimation(.easeInOut(duration: 1.5)) {
                            opacity = 1.0
                            fontSize = 36.0
                        }
                    }
                }
                
                Spacer()
                
                Text("99 like icardi")
            }
            
        }
    }
}

#Preview {
    SplashScreenView()
}
