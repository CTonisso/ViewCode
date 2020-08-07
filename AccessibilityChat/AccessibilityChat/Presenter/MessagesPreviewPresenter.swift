//
//  MessagesPreviewPresenter.swift
//  AccessibilityChat
//
//  Created by Bianca Itiroko on 16/10/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation

class MessagesPreviewPresenter: NSObject {
    let messageService = MessageServices()
    let userService = UserServices()
    var messagePreviews: [MessagePreview] = [] {
        didSet {
            messagePreviews.sort(by: { (message1, message2) -> Bool in
                return (message1.message.timestamp?.int32Value ?? 0) > (message2.message.timestamp?.int32Value ?? 0)
            })
        }
    }

    func getAllMessagesPreviews(completionHandler: @escaping ([MessagePreview]) -> Void) {
        var messagePreviews: [MessagePreview] = []
        var messagePreviewSet = Set<MessagePreview>()
        messageService.getAllMessagesPreviews { (userAndMessageDict) in
            for (user, message) in userAndMessageDict {
                if let name = user.name, let text = message.text {
                    messagePreviewSet.insert(MessagePreview(senderName: name, text: text, message: message))
                }
            }
            messagePreviews = []
            for message in messagePreviewSet {
                messagePreviews.append(message)
            }
            completionHandler(messagePreviews)
        }
    }

    func fetchAllMessagesPreviews(completionHandler: @escaping () -> Void) {
        self.getAllMessagesPreviews { (messagePreviews) in
            self.messagePreviews = messagePreviews
            completionHandler()
        }
    }
    func fetchUser(withUserID userID: String, completionHandler: @escaping (LocalUser) -> Void) {
        userService.fetchUser(withUserID: userID, completionHandler: completionHandler)
    }

}
