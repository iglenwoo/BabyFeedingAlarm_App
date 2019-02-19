//
//  MainTabBarController.swift
//  BabyFeedingAlarm_App
//
//  Created by Ingyu Woo on 2/3/19.
//  Copyright © 2019 Ingyu Woo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MainTabBarController: UITabBarController {

    var ref: DatabaseReference!

    /** @var handle
     @brief The handle for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        // NOTE: temporary signout...
        //try! Auth.auth().signOut()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        ref = Database.database().reference()

        /*if Auth.auth().currentUser != nil {
            print("[MainTabBarController] Current user is \"\(Auth.auth().currentUser.debugDescription)\"")
        } else {
            openLoginView()
        }*/
    }

    /* Listen for authentication state
     Attach a listener to the FIRAuth object.
     This listener gets called whenever the users' sign-in state changes
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        debugPrint("[MainTabBarController] viewWillAppear called")
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                debugPrint("[MainTabBarController] Signed out, open a login popup")
                self.openLoginView()
            } else {
                debugPrint("[MainTabBarController] Signed in?")
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        debugPrint("[MainTabBarController] viewWillDisappear called")
        Auth.auth().removeStateDidChangeListener(handle!)
        debugPrint("[MainTabBarController] removeStateDidChangeListener called")
    }
}

extension MainTabBarController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            debugPrint(error?.localizedDescription ?? "error?")
            return
        }

        let uid = authDataResult!.user.uid
        let email = authDataResult!.user.email ?? "none"
        debugPrint("[MainTabBarController] uid is \"\(uid)\"")
        debugPrint("[MainTabBarController] email is \"\(email)\"")

        let user: User = User(uid: uid, email: email)
        storeUser(user)
    }

    private func storeUser(_ user: User) {
        let df = Utils.getDateFormatter()

        let value = [
            "uid": user.uid,
            "email": user.email,
            "alarmIntervalMin": user.alarmIntervalMin,
            "created": df.string(from: Date())
        ] as [String : Any]

        self.ref.child("users/\(user.uid)").setValue(value)
    }
}

extension MainTabBarController {
    func openLoginView() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth()]

        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
}
