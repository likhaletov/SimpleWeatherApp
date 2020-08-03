//
//  String.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 20.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

extension String {
    
    static func roundDouble(number: Double) -> String {
        let result = String(format: "%.0f", number)
        return result
    }
    
    static func getNormalDate(unixEpochDate: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixEpochDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
//        formatter.dateStyle = .long
//        formatter.timeZone = .current
        let newDate = formatter.string(from: date as Date)
        return newDate
    }
    
}
