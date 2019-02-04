//
//  HistoryViewController.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/18/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HistoryTableViewController: UITableViewController {

    var feedTimes: [FeedTimer] = []

    var ref: DatabaseReference!
    var feedTimeRef: DatabaseReference?
    var handle: UInt?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatabase()

        print("viewDidLoad - History")
    }

    func configureDatabase() {
        ref = Database.database().reference()

        guard let currentUser = Auth.auth().currentUser else {
            print("currentUser is nil")
            return
        }

        let identifier = "feedTimes/\(currentUser.uid)"
        feedTimeRef = ref.child(identifier);
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let feedTimeRef = feedTimeRef else {
            print("feedTimeRef is nil")
            return
        }

        handle = feedTimeRef.observe(DataEventType.value, with: { snapshot in
            var feedTimes: [FeedTimer] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    feedTimes.append(FeedTimer(snapshot: snapshot)!)
                }
            }

            self.feedTimes = feedTimes
            self.tableView.reloadData()
        })
        print("viewWillAppear - History")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let handle = handle {
            self.ref.removeObserver(withHandle: handle)
        }

        print("viewWillDisappear - History")
    }
}

extension HistoryTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedTimes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell

        let feedTime = feedTimes[indexPath.row]
        let hours = String(feedTime.hours)
        let minutes = String(feedTime.minutes)
        let seconds = String(feedTime.seconds)
        cell.minutes.text = "\(hours) hour  \(minutes) minutes  \(seconds) seconds"

        return cell

    }
}