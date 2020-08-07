//
//  MessageMechanism.swift
//  AccessibilityChat
//
//  Created by Bianca Itiroko on 15/10/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import Firebase

class MessageMechanism {
    func fetchLastUserMessages(completionHandler: @escaping ([String: Message]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("LOG: Problems in getting current user")
            return
        }
        let group = DispatchGroup()
        var messagesDictionary = [String: Message]()

        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userID = snapshot.key
            Database.database().reference()
                .child("user-messages")
                .child(uid)
                .child(userID)
                .observe(.childAdded, with: { (snapshot) in
                let messageID = snapshot.key
                group.enter()

                self.fetchMessageWithMessageId(messageID) { (chatPartnerID, message) in
                    messagesDictionary[chatPartnerID] = message
                    group.leave()
                    group.notify(queue: .main) {
                        completionHandler(messagesDictionary)
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }

    fileprivate func fetchMessageWithMessageId(_ messageId: String,
                                               completionHandler: @escaping (String, Message) -> Void) {
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)

                if let chatPartnerId = message.chatPartnerId() {
                    completionHandler(chatPartnerId, message)
                }
            }
        }, withCancel: nil)
    }

    func fetchMessagesFromChat(destinationUser: LocalUser?, completionHandler: @escaping ([Message]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid, let toId = destinationUser?.userID else {
            return
        }
        var messages: [Message] = []
        let group = DispatchGroup()

        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)

        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            group.enter()
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)

            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }

                let message = Message(dictionary: dictionary)
                messages.append(message)
                group.leave()
                group.notify(queue: .main) {
                    completionHandler(messages)
                }
            }, withCancel: nil)
        })
    }

    func sendMessage(toUser user: LocalUser, message: String, audioMessageID: String?) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user.userID ?? ""
        let fromId = Auth.auth().currentUser?.uid ?? ""
        let timestamp = Int(Date().timeIntervalSince1970)
        var audioID: String = ""
        var sendTime: String {
            let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
            let hour = components.hour ?? 00
            let hourString = hour < 10 ? "0\(hour)" : "\(hour)"
            let minutes = components.minute ?? 00
            let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
            return "\(hourString):\(minutesString)"
        }
        if audioMessageID != nil {
            audioID = audioMessageID ?? ""
        }
        let values = ["text": message,
                      "toId": toId,
                      "fromId": fromId,
                      "timestamp": timestamp,
                      "audioMessageID": audioID,
                      "sendTime": sendTime] as [String: Any]

        childRef.updateChildValues(values) { (error, _) in
            if error != nil {
                print("LOG: \(error!)" )
                return
            }

            let userMessagesRef = Database.database().reference()
                .child("user-messages")
                .child(fromId)
                .child(toId)

            let messageId = childRef.key
            let update = [messageId: 1]
            userMessagesRef.updateChildValues(update)

            let recipientUserMessagesRef = Database.database().reference()
                .child("user-messages")
                .child(toId)
                .child(fromId)
            recipientUserMessagesRef.updateChildValues(update)
        }
    }
}
