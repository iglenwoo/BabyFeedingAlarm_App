//
//  AccountViewController.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/18/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("viewDidLoad - Setting")
    }
 
    // MARK: - Actions
    @IBAction func singOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
    }

}
