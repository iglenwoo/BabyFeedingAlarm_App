//
//  HistoryViewController.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/18/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {

    var feedTimes: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FeedTableViewCell")
        
        print("viewDidLoad - History")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("viewWillAppear - History")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FeedTime")

        do {
            feedTimes = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedTimes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath)

        let feedTime = feedTimes[indexPath.row]
        let startDate = feedTime.value(forKey: "startDate") as! Date
        cell.textLabel?.text = startDate.description
        
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