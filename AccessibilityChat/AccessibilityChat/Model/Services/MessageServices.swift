//
//  MessageServices.swift
//  AccessibilityChat
//
//  Created by Bianca Itiroko on 16/10/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class MessageServices: NSObject {
    let messageMechanism = MessageMechanism()
    let userMechanism = UserMechanism()

    /// Get messages previews
    ///
    /// - Parameter completionHandler: array of user and message
    func getAllMessagesPreviews(completionHandler: @escaping ([LocalUser: Message]) -> Void) {
        var userAndMessage: [LocalUser: Message] = [:]

        messageMechanism.fetchLastUserMessages { (idAndMessage) in
            for userID in idAndMessage.keys {
                self.userMechanism.fetchUser(withID: userID, completionHandler: { (user) in
                    userAndMessage[user] = idAndMessage[userID]
                    completionHandler(userAndMessage)
                })
            }
        }
    }

    /// Get messages
    ///
    /// - Parameters:
    ///   - user: user that received messages
    ///   - completionHandler: messages handler data
    func getAllMessages(toUser user: LocalUser, completionHandler: @escaping ([Message]) -> Void) {
        messageMechanism.fetchMessagesFromChat(destinationUser: user) { (messages) in
            completionHandler(messages)
        }
    }

    /// Send message
    ///
    /// - Parameters:
    ///   - user: user that will receive the message
    ///   - message: string message
    func sendMessage(toUser user: LocalUser, text: String, audioMessageID: String?) {
        messageMechanism.sendMessage(toUser: user, message: text, audioMessageID: audioMessageID)
    }
}
