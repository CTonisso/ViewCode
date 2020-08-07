//
//  LoginController+handlers.swift
//  gameofchats
//
//  Created by Brian Voong on 7/4/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }

        Auth.auth().createUser(withEmail: email,
                               password: password) { (_, error) in
            if error != nil {
                print(error!)
                return
            }
        }
    }

    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)

        usersReference.updateChildValues(values,
                                         withCompletionBlock: { (err, _) in

            if err != nil {
                print(err!)
                return
            }

            let user = LocalUser(dictionary: values)
            self.messagesController?.setupNavBarWithUser(user)

            self.dismiss(animated: true, completion: nil)
        })
    }

    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()

        picker.delegate = self
        picker.allowsEditing = true

        present(picker, animated: true, completion: nil)
    }

//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
//        var selectedImageFromPicker: UIImage?
//
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            selectedImageFromPicker = editedImage
//        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//            selectedImageFromPicker = originalImage
//        }
//
//        if let selectedImage = selectedImageFromPicker {
//            profileImageView.image = selectedImage
//        }
//
//        dismiss(animated: true, completion: nil)
//    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
}
