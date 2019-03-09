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
    var isInitialTimeStored = false;
    var fcmToken: String = ""

    var ref: DatabaseReference!

    @IBOutlet weak var FeedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var LRSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var startOutlet: UIBarButtonItem!
    @IBOutlet weak var pauseOutlet: UIBarButtonItem!
    @IBOutlet weak var stopOutlet: UIBarButtonItem!
    @IBOutlet weak var currentFeedTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.displayFCMToken(notification:)),
                name: Notification.Name("FCMToken"), object: nil)

        ref = Database.database().reference()

        let feedOption = FeedOption(feedType: FeedOption.FeedType.breastFeeding.rawValue, breastType: FeedOption.BreastType.Left.rawValue)
        feedTimer = FeedTimer(label: currentFeedTime, feedOption: feedOption)

        startOutlet.isEnabled = true;
        pauseOutlet.isEnabled = false;
        stopOutlet.isEnabled = false;
        print("viewDidLoad - Feed")
    }

    @objc func displayFCMToken(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
        if let fcmToken = userInfo["token"] as? String {
            self.fcmToken = fcmToken
            print("Received FCM token: \(fcmToken)")
        }
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

            FeedSegmentedControl.isEnabled = false
            LRSegmentedControl.isEnabled = false

            feedTimer.start()

            storeInitialTime()

        case .start:
            print("Already started... Do nothing")
        }
    }

    private func storeInitialTime() {
        if (!isInitialTimeStored) {
            guard let user = Auth.auth().currentUser else {
                print("Failed to store start time: cannot get current user")
                return;
            }

            let value = [
                "initialTime": String(feedTimer.initialTime),
                "fcmToken": self.fcmToken
            ] as [String: Any]

            self.ref.child("started/\(user.uid)").setValue(value)

            isInitialTimeStored = true;
        }
    }

    @IBAction func pauseTapped(_ sender: UIBarButtonItem) {
        switch feedTimer.status {
        case .start:
            startOutlet.isEnabled = true;
            pauseOutlet.isEnabled = false;
            stopOutlet.isEnabled = true;

            feedTimer.pause()
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

            FeedSegmentedControl.isEnabled = true
            if (feedTimer.feedOption.feedType != FeedOption.FeedType.bottleFeeding.rawValue) {
                LRSegmentedControl.isEnabled = true
            }

            feedTimer.stop()

            storeHistory()

            removeInitialTime()
        case .stop:
            print("Already stopped, Do nothing")
        }
    }

    func storeHistory() {
        guard let user = Auth.auth().currentUser else {
            print("Cannot get current user")
            return;
        }

        let dateKey = Utils.timeDoubleToString(feedTimer.initialTime)

        let value = [
            "initialTime": dateKey,
            "accumulatedTime": String(format: "%02d", Int(feedTimer.accumulatedTime)),
            "endTime": Utils.timeDoubleToString(feedTimer.endTime),
            "feedOption": feedTimer.feedOption.toDictionary()
        ] as [String : Any]

        // NOTE: setvalue vs updateChildValues ?
//        self.ref.child("feedTimes/\(user!.uid)/\(key)").setValue(value)
        self.ref.child("feedTimes/\(user.uid)/\(dateKey)").updateChildValues(value)

        isInitialTimeStored = false;
    }

    func removeInitialTime() {
        guard let user = Auth.auth().currentUser else {
            print("Cannot get current user")
            return;
        }

        self.ref.child("started/\(user.uid)").removeValue()

        isInitialTimeStored = false;
    }
}