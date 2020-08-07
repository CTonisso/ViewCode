//
//  LoginPresenter.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/28/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import Firebase

class LoginPresenter {
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func handleLogin(email: String?, password: String?) {
        guard let appDelegate = appDelegate else { return }
        
        guard let currentViewController = appDelegate.window?.rootViewController else { return }
        
        guard let email = email, let password = password else {
            print("Form is not valid")
            return
        }
    
        UserServices().logIn(email: email, password: password) { (uid, _) in
            if uid != nil {
                UserServices().fetchUser(withUserID: uid!, completionHandler: { (user) in
                    if let descriptionID = user.descriptionID, !descriptionID.isEmpty {
                        NavigationHelper.shared.switchRootViewController(to: appDelegate.initialTabBarController(),
                                                                         withAnimation: .revealFromTop)
                        currentViewController.dismiss(animated: true, completion: nil)
                    } else {
                        let recordViewController = UIStoryboard(name: "RecordDescription", bundle: nil)
                            .instantiateViewController(withIdentifier: "RecordDescription")
                            as? RecordDescriptionViewController
                        NavigationHelper.shared.switchRootViewController(to: recordViewController,
                                                                         withAnimation: .revealFromTop)
                        currentViewController.dismiss(animated: true, completion: nil)
                    }
                })
                
            } else {
                // TODO: user not logged
                print("TODO: user not logged")
            }
        }
    }
}
