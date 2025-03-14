//
//  YouDidItView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import SwiftUI

struct YouDidItView: View {
    let youDidIt:LocalizedStringKey = "you did it! here you can manage your alarm, change time and other things"
    var body: some View {
        
        
        ZStack {
            
            MainGradient(endRadius: 120,scaleX: 1.5,yellowColor: myDarkYellow)
                .cornerRadius(20)
                .frame(height: screenHeight / 4)
                .overlay(
                    HStack {
                        CoolTextView(text: youDidIt, size: 18)
                            .padding(.horizontal)
                            .padding(.horizontal)
                            .multilineTextAlignment(.leading)
                            .frame(width: screenWidth / 1.8)
                        Spacer()
                        
                        Image(partPerson)
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal)
                            .opacity(0.9)
                    }
                )
//                .clipShape(Rectangle())
                .padding()
            
        }
    }
}

#Preview {
    ZStack {
        myBlack.ignoresSafeArea()
        YouDidItView()
    }
}
