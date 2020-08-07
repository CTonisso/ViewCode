//
//  DatabaseMechanism.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/16/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import Firebase

class DatabaseMechanism {
    func uploadDescriptionId(userUid: String,
                             values: [String: String],
                             completion: @escaping (_ error: Error?) -> Void) {
        let reference: DatabaseReference = Database.database().reference().child("descriptions")
        let referenceChild: DatabaseReference = reference.child(userUid)

        referenceChild.setValue(values) { (error, _) in
            completion(error)
        }
    }

    func retrieveDescriptions(completion: @escaping (_ value: NSDictionary?) -> Void) {
        let userServices = UserServices()
        let reference: DatabaseReference = Database.database().reference().child("descriptions")

        reference.observeSingleEvent(of: .value) { (snapshot) in
            let dict = snapshot.value as? NSDictionary

            var newDict: [String: String] = [:]

            if let dict = dict {
                for (key, innerDict) in dict where key as? String != userServices.userUid() {
                    let innerDict2 = innerDict as? NSDictionary
                    newDict[(innerDict2?["user"] as? String)!] = innerDict2?["description"] as? String
                }
            }

            completion(NSDictionary(dictionary: newDict))
        }
    }

    func retrieveDescriptionId(userUid: String, completion: @escaping (_ name: String?) -> Void) {
        let reference: DatabaseReference = Database.database().reference().child("descriptions")
        let query: DatabaseQuery = reference.queryOrdered(byChild: "user").queryEqual(toValue: userUid)
        let limitedQuery: DatabaseQuery = query.queryLimited(toFirst: 1)

        limitedQuery.observeSingleEvent(of: .value) { (snapshot) in
            let value: NSDictionary? = snapshot.value as? NSDictionary
            let dict: NSDictionary? = value?[userUid] as? NSDictionary
            let description: String? = dict?["description"] as? String
            completion(description)
        }
    }
}
