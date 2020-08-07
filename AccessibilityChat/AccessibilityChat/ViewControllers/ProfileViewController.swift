//
//  ProfileViewController.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/18/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class ProfileViewController: ACViewController {
    let profilePresenter = ProfilePresenter()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    var user: LocalUser?

    override func viewDidLoad() {
        super.viewDidLoad()

        profilePresenter.fetchUser { (localUser) in
            self.user = localUser

            if let name = localUser.name,
                let age = localUser.age,
                let state = localUser.state,
                let city = localUser.city {
                self.nameLabel.text = name
                self.ageLabel.text = "Idade: \(age) anos"
                self.locationLabel.text = "Onde mora: \(city), \(state)"
            }
        }
    }

    @IBAction func listenDescription(_ sender: UIButton) {
        guard let user = self.user else { return }
        profilePresenter.retrieveDescription(user: user)
    }

    @IBAction func startChat(_ sender: Any) {
        guard let user = self.user else { return }
        showChatControllerForUser(user)
    }

    func showChatControllerForUser(_ user: LocalUser) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}
