//
//  Utils.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 2/3/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import Foundation

class Utils {
    static func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return formatter
    }
}
