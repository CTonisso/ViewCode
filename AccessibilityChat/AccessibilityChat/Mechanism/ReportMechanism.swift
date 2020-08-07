//
//  ReportMechanism.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 12/7/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import Firebase

class ReportMechanism {
    func report(user: LocalUser,
                reportType: String,
                comment: String,
                completion: @escaping (_ error: Error?) -> Void) {
        guard let userUid = user.userID else { return }
        
        let reference: DatabaseReference = Database.database().reference().child("reports")
        let referenceChild: DatabaseReference = reference.child(userUid)
        
        let values: [String: Any] = ["user": userUid, "reportType": reportType, "comment": comment]
        
        referenceChild.setValue(values) { (error, _) in
            completion(error)
        }
        
        updateReportedUser(user: user) { (error) in
            completion(error)
        }
    }
    
    fileprivate func updateReportedUser(user: LocalUser, completion: @escaping (_ error: Error?) -> Void) {
        guard let userUid = user.userID else { return }
        
        let reference: DatabaseReference = Database.database().reference().child("users")
        let referenceChild: DatabaseReference = reference.child(userUid)
        
        var dict = user.dictionary()
        if let date = dict["age"] as? Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            dict["age"] = formatter.string(from: date)
        }
        dict["reported"] = true
        referenceChild.setValue(dict) { (error, _) in
            completion(error)
        }
    }
}
