//
//  UserMechanism.swift
//  AccessibilityChat
//
//  Created by Bianca Itiroko on 15/10/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Firebase

class UserMechanism: NSObject {
    func fetchUser(withID userID: String, completionHandler: @escaping (LocalUser) -> Void) {
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }

            let user = LocalUser(dictionary: dictionary)
            user.userID = userID
            completionHandler(user)
        }, withCancel: nil)
    }

    func getUserUid() -> String? {
        return Auth.auth().currentUser?.uid
    }

    func logIn(email: String, password: String, completionHandler: @escaping (String?, Bool) -> Void) {
        var success: Bool = false
        var uid: String?
        
        let group = DispatchGroup()
        group.enter()
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error!.localizedDescription)
                uid = nil
                success = false
            } else {
                print("LOG: LogIn successful.")
                uid = result?.user.uid
                success = true
            }
            
            group.leave()
            group.notify(queue: .main) {
                completionHandler(uid, success)
            }
        }
    }
    
    func signOut(completionHandler: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completionHandler(true)
        } catch {
            completionHandler(false)
        }
    }

    func fetchAllUsers(completionHandler: @escaping ([LocalUser]) -> Void) {
        var users: [LocalUser] = []

        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = LocalUser(dictionary: dictionary)
                user.userID = snapshot.key
                users.append(user)
                completionHandler(users)
            }
        }, withCancel: nil)
    }

    func fetchAllUsers(without userUid: String, completionHandler: @escaping ([LocalUser]) -> Void) {
        var users: [LocalUser] = []

        let reference: DatabaseReference = Database.database().reference().child("users")
        reference.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? NSDictionary else {
                print("Problems in returning 'users' child of firebase")
                return
            }

            for (key, innerDict) in dict where key as? String != userUid {
                guard let innerDict2 = innerDict as? [String: AnyObject] else {
                    return
                }
                
                if let reported = innerDict2["reported"] as? Bool, reported == false {
                    users.append(LocalUser(dictionary: innerDict2))
                }
            }

            completionHandler(users)
        }
    }
    
    func updateDescriptionId(user: LocalUser, descriptionID: String, completionHandler: @escaping (Error?) -> Void) {
        guard let userUid = user.userID else {
            completionHandler(nil)
            return
        }
        
        let reference: DatabaseReference = Database.database().reference().child("users")
        let referenceChild: DatabaseReference = reference.child(userUid)
        
        var dict = user.dictionary()
        if let date = dict["age"] as? Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            dict["age"] = formatter.string(from: date)
        }
        dict["descriptionID"] = descriptionID
        referenceChild.setValue(dict) { (error, _) in
            completionHandler(error)
        }
    }
}
