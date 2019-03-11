//
// Created by Ingyu Woo on 2019-02-08.
// Copyright (c) 2019 Ingyu Woo. All rights reserved.
//

import Foundation
import Firebase

class FeedOption {

    var feedType: String
    var breastType: String?

    init(feedType: String, breastType: String?) {
        self.feedType = feedType
        if breastType != nil {
            self.breastType = breastType
        }
    }

    init?(snapshot: DataSnapshot) {
        let dict = snapshot.value as? [String:Any]
        let feedType = dict?["feedType"] as! String
        if dict?["breastType"] != nil {
            self.breastType = dict?["breastType"] as! String

        }

        self.feedType = feedType
    }

    func toDictionary() -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        dict["feedType"] = self.feedType
        dict["breastType"] = self.breastType

        return dict
    }
}

extension FeedOption {
    enum FeedType: String {
        case breastFeeding = "Breast Feeding"
        case breastPumping = "Breast Pumping"
        case bottleFeeding = "Bottle Feeding"
    }

    enum BreastType: String {
        case Left = "Left"
        case Right = "Right"
        case None = ""
    }
}