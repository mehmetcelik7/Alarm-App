//
//  SplashScreenView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isACtive: Bool = false
    @State private var opacity = 0.3
    @State private var fontSize = 12.0
    
    var body: some View {
        if isACtive {
            MainAlarmView()
        }else {
            ZStack {
                FourCoolCircles(color1: .red, color2: myYellow)
                
                VStack {
                    VStack(alignment: .leading, spacing: 0) {
                        CoolTextView(text: "99 like icardi", size: fontSize)
                        CoolTextView(text: "let's add an alarm", size: fontSize)
                        Spacer()
                            
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
                
                Image(welcome)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.7)
                Spacer()
            }
            .opacity(opacity)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    
                }
                
            }
            .onTapGesture {
                withAnimation {
                    isACtive = true
                }
            }
            
        }
    }
}

#Preview {
    SplashScreenView()
}
