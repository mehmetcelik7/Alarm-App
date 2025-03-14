//
//  TimeModel.swift
//  Alarm App
//
//  Created by mehmet Çelik on 14.03.2025.
//

import Foundation

struct TimeModel: Equatable, Comparable, Identifiable {
    static func < (lhs: TimeModel, rhs: TimeModel) -> Bool {
     
        return (lhs.hours < rhs.hours) || (lhs.hours == rhs.hours && lhs.minutes < rhs.minutes)
        
    }
    
    let id = UUID()
    let hours: Int
    let minutes: Int
    
}
