//
//  ChatHistoryTableViewCell.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/6/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Cartography

class ChatHistoryTableViewCell: UITableViewCell {
    let theme: Theme = UserDefaultsManager.getTheme()

    lazy var playButton: UIButton = {
        let view = UIButton()
        view.setImage(theme.chatHistoryPlayButton, for: .normal)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Stilu-SemiBold", size: 20)
        view.textColor = theme.chatHistoryNameLabelColor
        view.backgroundColor = .clear
        view.text = "Teste"
        view.numberOfLines = 0
        view.setupAdjustableFont()
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20)
        view.textColor = theme.chatHistoryTimeLabelColor
        view.backgroundColor = .clear
        view.text = "20:00"
        view.setupAdjustableFont()
        return view
    }()
    
    lazy var unreadNotificationsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = theme.chatHistoryNotificationBackgroundColor
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var unreadNotificationsLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18)
        view.textColor = theme.chatHistoryNotificationLabelColor
        view.backgroundColor = .clear
        view.text = "1"
        view.numberOfLines = 0
        view.setupAdjustableFont()
        return view
    }()
    
    lazy var enterButton: UIButton = {
        let view = UIButton()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitialState()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCorners()
    }
    
    func setupInitialState() {
        self.contentView.backgroundColor = theme.backgroundColor
        self.selectionStyle = .none
        addSubviews()
        setupPlayButton()
        setupNameLabel()
        setupTimeLabel()
        setupUnreadNotifications()
        setupEnterButton()
    }
    
    func addSubviews() {
        self.contentView.addSubview(playButton)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(timeLabel)
        self.unreadNotificationsContainer.addSubview(unreadNotificationsLabel)
        self.contentView.addSubview(unreadNotificationsContainer)
        self.contentView.addSubview(enterButton)
    }

    func setupPlayButton() {
        constrain(playButton) { button in
            guard let superview = button.superview else { return }
            button.height == 60
            button.width == 60
            button.centerY == superview.centerY
            button.left == superview.left + 18
//            button.top == superview.top + 14
//            button.bottom == superview.bottom - 14
        }
    }
    
    func setupNameLabel() {
        constrain(nameLabel, playButton, timeLabel) { name, button, time in
            guard let superview = name.superview else { return }
            name.left == button.right + 16
            name.top == superview.top + 14
            name.right == time.left - 16
        }
    }
    
    func setupTimeLabel() {
        constrain(timeLabel, nameLabel) { time, name in
            guard let superview = time.superview else { return }
            time.right == superview.right - 32
            time.top == name.top
            time.width >= 60
        }
    }
    
    func setupUnreadNotifications() {
        constrain(nameLabel, unreadNotificationsContainer, unreadNotificationsLabel, timeLabel,
                  playButton) { name, container, notification, time, button in
                    guard let superview = container.superview else { return }
                    container.right == time.right
                    container.left == name.left
                    container.bottom == superview.bottom - 14
                    container.top == name.bottom + 14
                    notification.top == container.top + 4
                    notification.bottom == container.bottom - 4
                    notification.left == container.left + 6
                    notification.right == container.right - 6
                    notification.centerY == container.centerY
        }
    }
    
    func setupEnterButton() {
        constrain(enterButton) { button in
            guard let superview = button.superview else { return }
            button.right == superview.right - 10
            button.centerY == superview.centerY
            button.height == 18
            button.width == 10
        }
    }
    
    func setupCorners() {
        unreadNotificationsContainer.layer.cornerRadius = unreadNotificationsContainer.bounds.height / 2
    }
    
}
