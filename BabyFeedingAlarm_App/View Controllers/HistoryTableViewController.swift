//
//  HistoryViewController.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/18/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import Firebase

class HistoryTableViewController: UITableViewController {

    var feedTimes: [FeedTimer] = []

    var ref: DatabaseReference!
    var feedTimeRef: DatabaseReference!
    var refHandle: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatabase()
        
        print("viewDidLoad - History")
    }

    func configureDatabase() {
        ref = Database.database().reference()

        let identifier = "feedTimes"
        feedTimeRef = ref.child(identifier);

        feedTimeRef.observe(DataEventType.value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    self.feedTimes.append(FeedTimer(snapshot: snapshot)!)
                }
            }

            self.tableView.reloadData()
        })
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("viewWillAppear - History")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedTimes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell

        let feedTime = feedTimes[indexPath.row]
        let time = String(feedTime.minutes) + " m"
        cell.minutes.text = time

        return cell
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