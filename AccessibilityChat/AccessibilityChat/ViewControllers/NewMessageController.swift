//
//  NewMessageController.swift
//  gameofchats
//
//  Created by Brian Voong on 6/29/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    let cellId = "cellId"
    var users = [LocalUser]()
    let userServices = UserServices()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain,
                                                           target: self, action: #selector(handleCancel))

        tableView.register(MessagePreviewTableViewCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }

    func fetchUser() {
        userServices.fetchAllUsers { users in
            self.users = users

            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId,
                                                       for: indexPath) as? MessagePreviewTableViewCell else {
            return UITableViewCell()
        }

        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
//        if let profileImageUrl = user.profileImageUrl {
//            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
//        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    var messagesController: MessagesController?

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            print("Dismiss completed")
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user)
        }
    }
}
