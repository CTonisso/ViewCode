//
//  FirebaseMechanism.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/16/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class StorageMechanism {
    func uploadAudio(directory: String, fileName: String, url: URL, completion: @escaping (_ error: Error?) -> Void) {
        let reference = Storage.storage().reference().child(directory).child(fileName)

        reference.putFile(from: url, metadata: nil) { (_, error) in
            completion(error)
        }
    }

    func retrieveAudio(directory: String,
                       fileName: String,
                       completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        let reference = Storage.storage().reference().child(directory).child(fileName)

        reference.getData(maxSize: 5*1024*1024) { (data, error) in
            completion(data, error)
        }
    }
}
