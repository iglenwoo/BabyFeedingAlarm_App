//
//  FeedTimerModel.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/21/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit

class FeedTimer {

    // MARK: - Properties

    let updateInterval: Double = 0.1
    var (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
    var status: Status = Status.stop
    var timer: Timer?
    var startDate: Date?
    var endDate: Date?
    var label: UILabel?
    
    // MARK: - Initialization
    
    init(label: UILabel) {
        self.label = label
    }
}

extension FeedTimer {

    // MARK: - Status

    enum Status {
        case start
        case pause
        case stop
    }
}

extension FeedTimer {
    func start() {
        if status == .stop {
            startDate = Date()
            (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
        }

        status = .start

        // create the timer object without scheduling it on a run loop
        self.timer = Timer.init(timeInterval: updateInterval, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        // The timer may fire at any time between its scheduled fire date and the scheduled fire date plus the tolerance.
        // A general rule, set the tolerance to at least 10% of the interval, for a repeating timer.
        timer?.tolerance = updateInterval * 0.2 //20%
        RunLoop.current.add(timer!, forMode: .common)
    }

    @objc func updateTime() {
        fractions += 1
        if (fractions > 9) {
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

        printTime()
    }

    func printTime() {
        switch status{
        case .stop:
            label?.text = "00:00:00"
        case .start, .pause:
            let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
            let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
            let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"

            label?.text = "\(hoursString):\(minutesString):\(secondsString)"
        }
    }
}

extension FeedTimer {
    func pause() {
        status = .pause

        timer?.invalidate()
    }
}

extension FeedTimer {
    func stop() {
        status = .stop

        endDate = Date()
        timer?.invalidate()

        printTime()
    }
}