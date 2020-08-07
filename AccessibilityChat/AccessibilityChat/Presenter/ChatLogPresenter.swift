//
//  ChatLogPresenter.swift
//  AccessibilityChat
//
//  Created by Bianca Itiroko on 16/10/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class ChatLogPresenter: NSObject {
    let messageService = MessageServices()
    let userService = UserServices()
    let audioService = AudioServices()

    func fetchMessages(toUser user: LocalUser, completionHandler: @escaping ([Message]) -> Void) {
        messageService.getAllMessages(toUser: user) { (messages) in
            completionHandler(messages)
        }
    }

    func fetchAudioData(from messages: [Message], completionHandler: @escaping ([Message]) -> Void) {
        let group = DispatchGroup()

        for message in messages {
            group.enter()
            if let audioMessageID = message.audioMessageID,
                let uuid = UUID(uuidString: audioMessageID), audioMessageID != "" {
                audioService.retrieveAudioMessage(uuid: uuid) { (data, error) in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                    }
                    message.audioData = data
                    group.leave()
                    group.notify(queue: .main, execute: {
                        completionHandler(messages)
                    })
                }
            }
        }
    }

    func sendMessage(toUser user: LocalUser, text: String, audioMessageID: String?) {
        messageService.sendMessage(toUser: user, text: text, audioMessageID: audioMessageID)
    }

    func sendAudioToStorage(url: URL, completionHandler: @escaping (String) -> Void) {
        audioService.uploadAudioMessage(url: url) { (uid, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            completionHandler(uid.description)
        }
    }
}
