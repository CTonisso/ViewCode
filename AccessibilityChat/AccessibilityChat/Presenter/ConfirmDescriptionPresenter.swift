//
//  ConfirmDescriptionPresenter.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/22/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation

class ConfirmDescriptionPresenter: NSObject {
    let audioUtils: AudioUtils = AudioUtils()

    func saveAudio() {
        let userServices = UserServices()
        let audioServices = AudioServices()

        // save to firebase
        if let userUid = userServices.userUid() {
            let uuid = UUID()

            // save to database
            let values: [String: String] = ["user": userUid, "description": uuid.uuidString]
            audioServices.uploadDescriptionId(userUid: userUid,
                                              values: values) { (error) in
                if error != nil {
                    print("LOG: \(error!.localizedDescription)")
                } else {
                    userServices.fetchUser(withUserID: userUid, completionHandler: { (user) in
                        userServices.updateDescriptionId(user: user,
                                                         descriptionID: uuid.uuidString,
                                                         completionHandler: { (error) in
                            if error != nil {
                                print("LOG: \(error!.localizedDescription)")
                            } else {
                                print("LOG: Upload descriptionID successful.")
                            }
                        })
                    })
                }
            }

            // save to storage
            audioServices.uploadAudioDescription(uuid: uuid, url: audioUtils.getAudio(), completion: { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("LOG: Upload audio description successful.")
                    // TODO
                }
            })
        }
    }

    func playAudio(url: URL) {
        audioUtils.play(url: url)
    }

    func duration(url: URL) -> TimeInterval {
        return audioUtils.duration(url: url)
    }
}
