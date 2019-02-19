//
// Created by Ingyu Woo on 2019-02-18.
// Copyright (c) 2019 Ingyu Woo. All rights reserved.
//

import Foundation
import Firebase

class User {
    var uid: String
    var email: String
    var alarmIntervalMin: Int = 20 // default: 20 minutes

    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}