//
//  HistoryViewController.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/18/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import CoreData

let contacts:[[String]] = [
    ["Elon Musk",       "+1-201-3141-5926"],
    ["Bill Gates",      "+1-202-5358-9793"],
    ["Tim Cook",        "+1-203-2384-6264"],
    ["Richard Branson", "+1-204-3383-2795"],
    ["Jeff Bezos",      "+1-205-0288-4197"],
    ["Warren Buffet",   "+1-206-1693-9937"],
    ["The Zuck",        "+1-207-5105-8209"],
    ["Carlos Slim",     "+1-208-7494-4592"],
    ["Bill Gates",      "+1-209-3078-1640"],
    ["Larry Page",      "+1-210-6286-2089"],
    ["Harold Finch",    "+1-211-9862-8034"],
    ["Sergey Brin",     "+1-212-8253-4211"],
    ["Jack Ma",         "+1-213-7067-9821"],
    ["Steve Ballmer",   "+1-214-4808-6513"],
    ["Phil Knight",     "+1-215-2823-0664"],
    ["Paul Allen",      "+1-216-7093-8446"],
    ["Woz",             "+1-217-0955-0582"]
]

class HistoryTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        
        print("viewDidLoad - History")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        
        print("\(#function) --- section = \(indexPath.section), row = \(indexPath.row)")
        cell.textLabel?.text = contacts[indexPath.row][0]
        
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
