//
//  FeedViewController.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/18/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import CoreData

class FeedViewController: UIViewController {

    var feedTimer: FeedTimer!
    
    @IBOutlet weak var startOutlet: UIBarButtonItem!
    @IBOutlet weak var pauseOutlet: UIBarButtonItem!
    @IBOutlet weak var stopOutlet: UIBarButtonItem!
    @IBOutlet weak var currentFeedTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        feedTimer = FeedTimer(label: currentFeedTime)

        startOutlet.isEnabled = true;
        pauseOutlet.isEnabled = false;
        stopOutlet.isEnabled = false;
        print("viewDidLoad - Feed")
    }

}

extension FeedViewController {

    // MARK: - Feed Controllers

    @IBAction func startTapped(_ sender: UIBarButtonItem) {
        switch feedTimer.status {
        case .stop, .pause:
            startOutlet.isEnabled = false;
            pauseOutlet.isEnabled = true;
            stopOutlet.isEnabled = true;

            feedTimer!.start()
        case .start:
            print("Already started... Do nothing")
        }
    }

    @IBAction func pauseTapped(_ sender: UIBarButtonItem) {
        switch feedTimer.status {
        case .start:
            startOutlet.isEnabled = true;
            pauseOutlet.isEnabled = false;
            stopOutlet.isEnabled = true;

            feedTimer?.pause()
        case .pause:
            print("Already paused, Do nothing")
        case .stop:
            print("Already stopped, Do nothing")
        }
    }

    @IBAction func stopTapped(_ sender: Any) {
        switch feedTimer.status {
        case .start, .pause:
            startOutlet.isEnabled = true;
            pauseOutlet.isEnabled = false;
            stopOutlet.isEnabled = false;

            feedTimer?.stop()

            // TODO: store feeding data

        case .stop:
            print("Already stopped, Do nothing")
        }
    }

}