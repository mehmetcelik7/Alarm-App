//
//  Sound Constants.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import Foundation

enum Sounds: String, CaseIterable, Codable {
    
    case wake_up = "Sound Wake up"
    case lagrima = "Lagrima"
    
    func formatSoundName() -> String {
        String(describing: self)
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }
}
