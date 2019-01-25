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

    var feedTimer: FeedTimer?
    
    @IBOutlet weak var startOutlet: UIBarButtonItem!
    @IBOutlet weak var pauseOutlet: UIBarButtonItem!
    @IBOutlet weak var stopOutlet: UIBarButtonItem!
    @IBOutlet weak var currentFeedTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        feedTimer = FeedTimer(label: currentFeedTime)

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
            feedTimer!.start()
        case .start:
            print("Already started... Do nothing")
        }
    }

    @IBAction func stopTapped(_ sender: Any) {
        switch feedStatus {
        case .start, .pause:
            startOutlet.isEnabled = true;
            pauseOutlet.isEnabled = false;
            stopOutlet.isEnabled = false;
            
            feedStatus = .stop
            feedTimer?.stop()

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
            feedTimer?.pause()
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
