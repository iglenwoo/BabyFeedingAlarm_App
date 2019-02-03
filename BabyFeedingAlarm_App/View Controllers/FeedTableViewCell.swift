//
//  FeedTableViewCell.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 1/25/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var minutes: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
