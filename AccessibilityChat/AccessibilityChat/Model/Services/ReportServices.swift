//
//  ReportServices.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 12/7/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation

class ReportServices {
    let databaseMechanism = ReportMechanism()
    
    func report(user: LocalUser,
                reportType: String,
                comment: String,
                completion: @escaping (_ error: Error?) -> Void) {
        databaseMechanism.report(user: user, reportType: reportType,
                                 comment: comment, completion: completion)
    }
}
