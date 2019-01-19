//
//  FeedViewController.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/18/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    var timer: Timer?
    var startDate: Date!
    
    @IBOutlet weak var currentFeedTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad - Feed")
    }
    
    @IBAction func startTapped(_ sender: UIBarButtonItem) {
        self.startDate = Date()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimeLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimeLabel() {
        let elapsed = Date().timeIntervalSince(self.startDate)
        let hundreds = Int((elapsed - trunc(elapsed)) * 100.0)
        let seconds = Int(trunc(elapsed))
        let minutes = seconds / 60
        let hundredsStr = String(format: "%02d", hundreds)
        let secondsStr = String(format: "%02d", seconds)
        let minutesStr = String(format: "%02d", minutes)
        currentFeedTime.text = "\(minutesStr):\(secondsStr).\(hundredsStr)"
    }
    
    @IBAction func stopTapped(_ sender: Any) {
        
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
