//
//  Utils.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 2/3/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import Foundation

class Utils {

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        return formatter
    }()

    static func timeDoubleToString(_ time: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        return dateFormatter.string(from: date)
    }

    static func currentDateToString() -> String {
        return dateFormatter.string(from: Date())
    }

    static func dateStringToDouble(_ time: String) -> Double {
        guard let date = dateFormatter.date(from: time) else {
            return 0.0
        }

        return date.timeIntervalSince1970 as Double
    }

    static func stringToDouble(_ time: String) -> Double {
        return Double(time) ?? 0.0
    }

    static func doubleToPrintString(_ time: Double) -> String {
        let interval = Int(time)
        let hours = interval / 3600
        let minutes = interval / 60 % 60
        let seconds = interval % 60

        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
