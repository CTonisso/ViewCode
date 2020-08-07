//
//  UserServices.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/16/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation

class UserServices {
    let userMechanism = UserMechanism()

    /// Log in
    func logIn(email: String, password: String, completionHandler: @escaping (String?, Bool) -> Void) {
        userMechanism.logIn(email: email, password: password) { (uid, success) in
            completionHandler(uid, success)
        }
    }
    
    /// Sign out
    func signOut(completionHandler: @escaping (Bool) -> Void) {
        userMechanism.signOut { (success) in
            completionHandler(success)
        }
    }

    /// Fetch user uid
    ///
    /// - Returns: string of uid's user
    func userUid() -> String? {
        return userMechanism.getUserUid()
    }

    /// Fetch user
    ///
    /// - Parameters:
    ///   - userID: uid of the user
    ///   - completionHandler: local user handler data
    func fetchUser(withUserID userID: String, completionHandler: @escaping (LocalUser) -> Void) {
        userMechanism.fetchUser(withID: userID, completionHandler: completionHandler)
    }

    func fetchAllUsers(completionHandler: @escaping ([LocalUser]) -> Void) {
        userMechanism.fetchAllUsers(completionHandler: completionHandler)
    }

    func fetchAllUsers(without userUid: String, completionHandler: @escaping ([LocalUser]) -> Void) {
        userMechanism.fetchAllUsers(without: userUid, completionHandler: completionHandler)
    }
    
    func updateDescriptionId(user: LocalUser, descriptionID: String, completionHandler: @escaping (Error?) -> Void) {
        userMechanism.updateDescriptionId(user: user,
                                          descriptionID: descriptionID,
                                          completionHandler: completionHandler)
    }
}
