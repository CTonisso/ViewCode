//
//  ProfilePresenter.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/18/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import AVFoundation

class ProfilePresenter: NSObject {
    let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    var audioPlayer: AVAudioPlayer?

    func fetchUser(completion: @escaping (LocalUser) -> Void) {
        let userServices = UserServices()

        if let userUid = userServices.userUid() {
            userServices.fetchUser(withUserID: userUid) { (localUser) in
                completion(localUser)
            }
        }
    }

    func retrieveDescription(user: LocalUser) {
        let audioServices = AudioServices()

        if let descriptionID = user.descriptionID, let uuid = UUID(uuidString: descriptionID) {
            audioServices.retrieveAudioDescription(uuid: uuid, completion: { (data, error) in
                if error != nil {
                    print("LOG: \(error!.localizedDescription)")
                } else {
                    self.playAudioDescription(data: data)
                }
            })
        }
    }
}

extension ProfilePresenter: AVAudioPlayerDelegate {
    func playAudioDescription(data: Data?) {
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback,
                                         mode: .spokenAudio,
                                         options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("LOG: audioSession error: \(error.localizedDescription)")
        }

        if let data = data {
            do {
                try audioPlayer = AVAudioPlayer(data: data)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("LOG: audioPlayer error: \(error.localizedDescription)")
            }
        }
    }
}
