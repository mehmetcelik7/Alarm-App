//
//  ImageDisplayView.swift
//  Alarm App
//
//  Created by mehmet Çelik on 16.03.2025.
//

import SwiftUI

struct ImageDisplayView: View {
    let name: String
    let width: CGFloat
    
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: width)
    }
}

#Preview {
    HStack {
        ImageDisplayView(name: standartViewImage, width: 50)
        Spacer()
        ImageDisplayView(name: circularViewImage, width: 50)

    }
    .padding()
}
