//
//  RecordDescriptionPresenter.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/17/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import Firebase

class RecordDescriptionPresenter: NSObject {
    let audioServices: AudioServices = AudioServices()

    let audioUtils: AudioUtils = AudioUtils()

    func fetchUser(completion: @escaping (LocalUser) -> Void) {
        let userServices = UserServices()

        if let userUid = userServices.userUid() {
            userServices.fetchUser(withUserID: userUid) { (localUser) in
                completion(localUser)
            }
        }
    }

    func startRecording() {
        audioUtils.startRecording()
    }

    func stopRecording() -> URL? {
        return audioUtils.stopRecording()
    }
}
