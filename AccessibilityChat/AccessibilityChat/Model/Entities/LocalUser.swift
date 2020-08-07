//
//  User.swift
//  gameofchats
//
//  Created by Brian Voong on 6/29/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class LocalUser: NSObject {
    var userID: String?
    var name: String?
    var email: String?
    var age: Date?
    var city: String?
    var state: String?
    var descriptionID: String?
    var profileImageUrl: String?
    var acceptedTerms: Bool?
    var reported: Bool?
    
    override init() {
    }
    
    init(userID: String?,
         name: String?,
         email: String?,
         age: Date?,
         city: String?,
         state: String?,
         descriptionID: String?,
         acceptedTerms: Bool?,
         reported: Bool?) {
        self.userID = userID
        self.name = name
        self.email = email
        self.age = age
        self.city = city
        self.state = state
        self.descriptionID = descriptionID
        self.acceptedTerms = acceptedTerms
        self.reported = reported
    }

    init(dictionary: [String: AnyObject]) {
        self.userID = dictionary["userID"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.age = TimeFormat.date(str: dictionary["age"] as? String ?? "")
        self.city = dictionary["city"] as? String
        self.state = dictionary["state"] as? String
        self.descriptionID = dictionary["descriptionID"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.acceptedTerms = dictionary["acceptedTerms"] as? Bool
        self.reported = dictionary["reported"] as? Bool
    }
    
    func dictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["userID"] = self.userID
        dict["name"] = self.name
        dict["email"] = self.email
        dict["age"] = self.age
        dict["city"] = self.city
        dict["state"] = self.state
        dict["descriptionID"] = self.descriptionID
        dict["acceptedTerms"] = self.acceptedTerms
        dict["reported"] = self.reported
        return dict
    }
}
