//
//  ViewController.swift
//  gameofchats
//
//  Created by Brian Voong on 6/24/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase

private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (left?, right?):
        return left < right
    case (nil, _?):
        return true
    default:
        return false
    }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (left?, right?):
        return left > right
    default:
        return rhs < lhs
    }
}

class MessagesController: UITableViewController {
    let cellId = "cellId"
    let messagesPresenter = MessagesPreviewPresenter()
    var contentSizeChanged = false
    let theme: Theme = UserDefaultsManager.getTheme()
    var messages = [Message]()
    var messagesDictionary = [String: Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        tableView.register(MessagePreviewTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(ChatHistoryTableViewCell.self, forCellReuseIdentifier: "ChatHistory")
        tableView.delegate = self
        tableView.dataSource = self
        self.attemptReloadOfTable()
        setTheme()
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeChanged(_:)),
                                               name: UIContentSizeCategory.didChangeNotification, object: nil)

        self.navigationItem.title = "Conversas"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let theme: Theme = UserDefaultsManager.getTheme()

        let tabBar = self.navigationController?.tabBarController?.tabBar
        self.navigationController?.navigationBar.barStyle = theme.navigationBarStyle
        tabBar?.barStyle = theme.navigationBarStyle

        let explore = tabBar?.items?[0]
        explore?.selectedImage = theme.selectedExploreIcon.withRenderingMode(.alwaysOriginal)
        explore?.image = theme.unselectedExploreIcon.withRenderingMode(.alwaysOriginal)

        let messages = tabBar?.items?[1]
        messages?.selectedImage = theme.selectedMessagesIcon.withRenderingMode(.alwaysOriginal)
        messages?.image = theme.unselectedMessagesIcon.withRenderingMode(.alwaysOriginal)

        let settings = tabBar?.items?[2]
        settings?.selectedImage = theme.selectedSettingsIcon.withRenderingMode(.alwaysOriginal)
        settings?.image = theme.unselectedSettingsIcon.withRenderingMode(.alwaysOriginal)
        
        navigationController?.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        
        messagesPresenter.fetchAllMessagesPreviews {
            self.tableView.reloadData()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UserDefaultsManager.getTheme().statusBarStyle
    }
    
    func observeUserMessages() {
        messagesPresenter.fetchAllMessagesPreviews {
            self.tableView.reloadData()
        }
    }

    func setTheme() {
        self.tableView.backgroundColor = theme.backgroundColor
        self.view.backgroundColor = theme.backgroundColor
    }

    @objc func preferredContentSizeChanged(_ notification: Notification) {
        contentSizeChanged = !contentSizeChanged
    }

    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                          selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
        self.timer?.fire()
    }

    var timer: Timer?

    @objc func handleReloadTable() {
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let messages = messagesPresenter.messagePreviews
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatHistory",
                                                       for: indexPath) as? ChatHistoryTableViewCell else {
                                                        return UITableViewCell()
        }

        let message = messagesPresenter.messagePreviews[indexPath.row]
        cell.unreadNotificationsLabel.text = message.text
        cell.nameLabel.text = message.senderName
        cell.timeLabel.text = message.message.sendTime
        cell.detailTextLabel?.numberOfLines = 1
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        cell.isAccessibilityElement = true

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messagesPresenter.messagePreviews[indexPath.row].message

        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }

        messagesPresenter.fetchUser(withUserID: chatPartnerId) { (user) in
            self.showChatControllerForUser(user)
        }
    }

    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }

    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
//        else {
//            fetchUserAndSetupNavBarTitle()
//        }
    }

//    func fetchUserAndSetupNavBarTitle() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            //for some reason uid = nil
//            return
//        }
//        messagesPresenter.fetchUser(withUserID: uid) { (user) in
//            self.setupNavBarWithUser(user)
//        }
//    }

    func setupNavBarWithUser(_ user: LocalUser) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()

        observeUserMessages()

        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //        titleView.backgroundColor = UIColor.redColor()

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)

        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }

        containerView.addSubview(profileImageView)

        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true

        self.navigationItem.titleView = titleView
    }

    func showChatControllerForUser(_ user: LocalUser) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }

    @objc func handleLogout() {

        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }

        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }
}
