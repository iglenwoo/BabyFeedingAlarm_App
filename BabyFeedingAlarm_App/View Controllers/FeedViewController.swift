//
//  FeedViewController.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/18/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import CoreData

enum FeedStatus {
    case stop
    case start
    case pause
}

let updateInterval: Double = 0.01
var feedStatus: FeedStatus = FeedStatus.stop

class FeedViewController: UIViewController {

    var (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
    var timer: Timer?
    
    @IBOutlet weak var startOutlet: UIBarButtonItem!
    @IBOutlet weak var pauseOutlet: UIBarButtonItem!
    @IBOutlet weak var stopOutlet: UIBarButtonItem!
    @IBOutlet weak var currentFeedTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopOutlet.isEnabled = true;
        pauseOutlet.isEnabled = false;
        stopOutlet.isEnabled = false;
        print("viewDidLoad - Feed")
    }
    
    @IBAction func startTapped(_ sender: UIBarButtonItem) {
        switch feedStatus {
        case .stop, .pause:
            startOutlet.isEnabled = false;
            pauseOutlet.isEnabled = true;
            stopOutlet.isEnabled = true;
            
            feedStatus = .start
            setTimer(timeInterval: updateInterval)
        case .start:
            print("Already started... Do nothing")
        }
    }

    func setTimer(timeInterval: TimeInterval) {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.updateTimeLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimeLabel() {
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
        
        currentFeedTime.text = "\(hoursString):\(minutesString):\(secondsString)"
    }
    
    @IBAction func stopTapped(_ sender: Any) {
        switch feedStatus {
        case .start, .pause:
            startOutlet.isEnabled = true;
            pauseOutlet.isEnabled = false;
            stopOutlet.isEnabled = false;
            
            feedStatus = .stop
            timer?.invalidate()
            (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
            currentFeedTime.text = "00:00:00"
            
        // TODO: store feeding data
            
        case .stop:
            print("Already stopped, Do nothing")
        }
    }

    @IBAction func pauseTapped(_ sender: UIBarButtonItem) {
        switch feedStatus {
        case .start:
            startOutlet.isEnabled = true;
            pauseOutlet.isEnabled = false;
            stopOutlet.isEnabled = true;
            
            feedStatus = .pause
            timer?.invalidate()
        case .pause:
            print("Already paused, Do nothing")
        case .stop:
            print("Already stopped, Do nothing")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
