//
//  FeedTimerModel.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/21/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import Firebase

class FeedTimer {

    // MARK: - Properties

    static let updateInterval: Double = 0.1
    var status: Status = Status.stop
    var feedOption: FeedOption!

    var initialTime: Double = 0;
    var startTime: Double = 0;
    var accumulatedTime: Double = 0;
    var elapsedTime: Double = 0;
    var endTime: Double = 0;

    var timer: Timer?
    var label: UILabel?

    // MARK: - Initialization
    
    init(label: UILabel, feedOption: FeedOption) {
        self.label = label
        self.feedOption = feedOption
    }

    init?(snapshot: DataSnapshot) {
        let dict = snapshot.value as? [String:Any]

        let initialTime = Utils.dateStringToDouble(dict?["initialTime"] as! String)
        let accumulatedTime = Utils.stringToDouble(dict?["accumulatedTime"] as! String)
        let endTime = Utils.dateStringToDouble(dict?["endTime"] as! String)
        let feedOption = FeedOption(snapshot: snapshot.childSnapshot(forPath: "feedOption"))

        self.initialTime = initialTime
        self.accumulatedTime = accumulatedTime
        self.endTime = endTime
        self.feedOption = feedOption
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
            initialTime = Date().timeIntervalSince1970
            startTime = initialTime
            accumulatedTime = 0
            elapsedTime = 0
        } else if status == .pause {
            startTime = Date().timeIntervalSince1970
        }

        status = .start

        // create the timer object without scheduling it on a run loop
        self.timer = Timer.init(timeInterval: FeedTimer.updateInterval, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        // The timer may fire at any time between its scheduled fire date and the scheduled fire date plus the tolerance.
        // A general rule, set the tolerance to at least 10% of the interval, for a repeating timer.
        timer?.tolerance = FeedTimer.updateInterval * 0.2 //20%
        RunLoop.current.add(timer!, forMode: .common)
    }

    @objc func updateTime() {
        elapsedTime = Date().timeIntervalSince1970 - startTime

        printTime()
    }

    func printTime() {
        switch status{
        case .stop:
            label?.text = "00:00:00"
        case .start, .pause:
            let formattedString = Utils.doubleToPrintString(accumulatedTime + elapsedTime)
            label?.text = formattedString
        }
    }
}

extension FeedTimer {
    func pause() {
        status = .pause

        accumulatedTime += Date().timeIntervalSince1970 - startTime

        timer?.invalidate()
    }
}

extension FeedTimer {
    func stop() {
        if status == .start {
            accumulatedTime += Date().timeIntervalSince1970 - startTime
        }
        endTime = Date().timeIntervalSince1970
        timer?.invalidate()

        status = .stop

        printTime()
    }
}
