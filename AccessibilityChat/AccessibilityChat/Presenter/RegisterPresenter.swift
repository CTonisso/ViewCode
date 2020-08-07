//
//  RegisterPresenter.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/28/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import Firebase

class RegisterPresenter {
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    fileprivate func createUser(_ email: String,
                                _ password: String,
                                _ userInfo: LocalUser,
                                _ completion: @escaping (ConfigForm) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if error == nil {
                print("You have successfully signed up")
                let userID = Auth.auth().currentUser?.uid ?? ""
                var values = userInfo.dictionary()
                if let date = values["age"] as? Date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    values["age"] = formatter.string(from: date)
                } else {
                    values["age"] = nil
                }
                values["userID"] = userID
                self.registerUserIntoDatabaseWithUID(userID, values: values as [String: AnyObject])
                let recordViewController = UIStoryboard(name: "RecordDescription", bundle: nil)
                    .instantiateViewController(withIdentifier: "RecordDescription")
                    as? RecordDescriptionViewController
                
                NavigationHelper.shared.switchRootViewController(to: recordViewController,
                                                                 withAnimation: .revealFromTop)
                
                self.appDelegate?.window?.rootViewController?.dismiss(animated: true,
                                                                      completion: nil)
                
                completion(ConfigForm.success)
            } else {
                let alertController = UIAlertController(title: "Error",
                                                        message: error?.localizedDescription,
                                                        preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.appDelegate?.window?.rootViewController?.present(alertController,
                                                                      animated: true,
                                                                      completion: nil)
            }
        }
    }
    
    func handleNewUser(userInfo: LocalUser, passwords: (String?, String?), completion: @escaping (ConfigForm) -> Void) {
        guard let name = userInfo.name, name.isEmpty == false else {
            completion(ConfigForm.emptyName)
            return
        }
        
        guard let email = userInfo.email, ValidationUtils.isValidEmail(testStr: email) else {
            completion(ConfigForm.wrongEmail)
            return
        }

        guard let pass = passwords.0, pass.count >= 6 else {
            completion(ConfigForm.weakPassword)
            return
        }
        
        guard let password = passwords.0, let confirmPassword = passwords.1, password == confirmPassword else {
            completion(ConfigForm.unmatchingPassword)
            return
        }
        
        guard userInfo.age != nil else {
            completion(ConfigForm.invalidBirth)
            return
        }
        
        guard userInfo.state != nil || userInfo.state != "" else {
            completion(ConfigForm.state)
            return
        }
        
        guard userInfo.city != nil || userInfo.city != "" else {
            completion(ConfigForm.city)
            return
        }
        
        createUser(email, password, userInfo, completion)
    }
    
    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values,
                                         withCompletionBlock: { (error, _) in
                                            if error != nil {
                                                print(error!)
                                                return
                                            }
                                            
                                            let user = LocalUser(dictionary: values)
//                                            self.messagesController?.setupNavBarWithUser(user)
                                            
                                            self.appDelegate?.window?.rootViewController?.dismiss(animated: true,
                                                                                                  completion: nil)
        })
    }
    
    func navigateTo(viewController: UIViewController) {
        NavigationHelper.shared.switchRootViewController(to: viewController, withAnimation: .revealFromTop)
    }
}
