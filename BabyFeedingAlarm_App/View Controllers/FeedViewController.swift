//
//  FeedViewController.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/18/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FeedViewController: UIViewController {

    var feedTimer: FeedTimer!

    var ref: DatabaseReference!

    @IBOutlet weak var LRSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var startOutlet: UIBarButtonItem!
    @IBOutlet weak var pauseOutlet: UIBarButtonItem!
    @IBOutlet weak var stopOutlet: UIBarButtonItem!
    @IBOutlet weak var currentFeedTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()

        let feedOption = FeedOption(feedType: FeedOption.FeedType.breastFeeding.rawValue, breastType: FeedOption.BreastType.Left.rawValue)
        feedTimer = FeedTimer(label: currentFeedTime, feedOption: feedOption)

        startOutlet.isEnabled = true;
        pauseOutlet.isEnabled = false;
        stopOutlet.isEnabled = false;
        print("viewDidLoad - Feed")
    }

    @IBAction func LRindexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 :
            feedTimer.feedOption.breastType = FeedOption.BreastType.Left.rawValue
        case 1:
            feedTimer.feedOption.breastType = FeedOption.BreastType.Right.rawValue
        default:
            break
        }
    }
    @IBAction func BBBindexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            feedTimer.feedOption.feedType = FeedOption.FeedType.breastFeeding.rawValue
            LRSegmentedControl.isEnabled = true
        case 1:
            feedTimer.feedOption.feedType = FeedOption.FeedType.breastPumping.rawValue
            LRSegmentedControl.isEnabled = true
        case 2:
            feedTimer.feedOption.feedType = FeedOption.FeedType.bottleFeeding.rawValue
            feedTimer.feedOption.breastType = nil
            LRSegmentedControl.isEnabled = false
        default:
            break
        }
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

            storeData()

        case .stop:
            print("Already stopped, Do nothing")
        }
    }

    func storeData() {
        let user = Auth.auth().currentUser

        let df = Utils.getDateFormatter()
        let key = df.string(from: feedTimer.startDate!)

        let value = [
            "startDate": key,
            "hours": feedTimer.hours,
            "minutes": feedTimer.minutes,
            "seconds": feedTimer.seconds,
            "fractions": feedTimer.fractions,
            "endDate": df.string(from: feedTimer.endDate!),
            "feedOption": feedTimer.feedOption.toDictionary()
        ] as [String : Any]

        // NOTE: setvalue vs updateChildValues ?
//        self.ref.child("feedTimes/\(user!.uid)/\(key)").setValue(value)
        self.ref.child("feedTimes/\(user!.uid)/\(key)").updateChildValues(value)
    }
}
