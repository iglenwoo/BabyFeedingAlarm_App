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

        // TODO: 3. show more info e.g. feedType, Group by date?
        let feedTime = feedTimes[indexPath.row]

        let formattedString = Utils.doubleToPrintString(feedTime.accumulatedTime)

        cell.minutes.text = formattedString

        return cell

    }

    // TODO: 4. update history
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let currentUser = Auth.auth().currentUser else {
            print("currentUser is nil")
            return
        }

        if editingStyle == .delete {
            // Delete the row from the data source
            let feedTime = feedTimes[indexPath.row]
            let key = Utils.timeDoubleToString(feedTime.initialTime)
            let identifier = "feedTimes/\(currentUser.uid)/\(key)"
            ref.child(identifier).removeValue();

            feedTimes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}