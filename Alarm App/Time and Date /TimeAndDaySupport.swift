//
//  TimeAndDaySupport.swift
//  Alarm App
//
//  Created by mehmet Çelik on 13.03.2025.
//

import Foundation


func getTimeFromDate(date: Date) -> String {
    let result = getTimeComponents(date: date)
    let hour = result.hour
    let minute = result.minute
    
    let time =  String(format: "%02d:%02d",hour,minute)
    return time
}

func addHourToDate(date: Date, numHours: Int, numMinutes: Int) -> Date {
    
    date.addingTimeInterval(TimeInterval(numMinutes * 60 + numHours * 3600))
    
}

func getTimeComponents(date:Date) ->(hour: Int, minute: Int, day: Int, month: Int, year: Int) {
    let components = Calendar.current.dateComponents([.hour,.minute,.day,.month,.year], from: date)
    
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let day = components.day ?? 0
    let month = components.month ?? 0
    let year = components.year ?? 0
    
    return (hour: hour, minute: minute, day: day, month: month, year: year)

}

func dateToPercent(date: Date) ->CGFloat {
    let result = getTimeComponents(date:date)
    
    return CGFloat(result.hour) / 24 + CGFloat(result.minute) / (60 * 24)
}

extension Date {
    static func - (lhs:Date, rhs:Date) -> TimeInterval {
        
        lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

func formatDate(date: Date) -> String {
    
    let result = getTimeComponents(date: date)
    return "\(result.day)-\(result.month)-\(result.year)(\(result.hour):\(result.minute))"
}

func DateToTimeModel(date: Date) -> TimeModel {
    let result = getTimeComponents(date: date)
    
    return TimeModel(hours: result.hour, minutes: result.minute)
}
