//
//  TimeFormat.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/23/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation

class TimeFormat {
    static func format(seconds: Int) -> String {
        return String(format: "%02i:%02i", seconds / 60, seconds % 60)
    }
    
    static func date(str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: str)
    }
 
    static func age(date: Date) -> Int? {
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        return calendar.components(.year, from: date, to: Date(), options: []).year
    }
}
