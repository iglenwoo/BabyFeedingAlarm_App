//
//  FeedTimerModel.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/21/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit

class FeedTimer {

    //MARK: Properties

    let updateInterval: Double = 0.01
    var (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
    var curStatus = Status.stop
    var timer: Timer?
    var label: UILabel?
}

extension FeedTimer {

    //MARK: Initialization

    convenience init(label: UILabel) {
        self.init(label: <#UILabel#>)
//        self.label = label
        self.timer = Timer.init(timeInterval: updateInterval, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
}

extension FeedTimer {

    //MARK: Status

    enum Status {
        case start
        case pause
        case stop
    }
}

extension FeedTimer {
    func start() {
        curStatus = .start

        RunLoop.current.add(timer!, forMode: .common)
    }

    @objc func updateTime() {
        fractions += 1
        if (fractions > 99) {
            seconds += 1
            fractions = 0
        }

        if (seconds == 60) {
            minutes += 1
            seconds = 0
        }

        if (minutes == 60) {
            hours += 1
            minutes = 0
        }

        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"

        label?.text = "\(hoursString):\(minutesString):\(secondsString)"
    }

}
