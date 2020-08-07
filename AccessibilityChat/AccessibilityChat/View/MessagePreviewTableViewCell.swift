//
//  PreviewMessageTableViewCell.swift
//  AccessibilityChat
//
//  Created by Bianca Itiroko on 16/10/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class MessagePreviewTableViewCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let theme: Theme = UserDefaultsManager.getTheme()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        addSubview(profileImageView)
        addSubview(timeLabel)

        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true

        //need x,y,width,height anchors
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true

        if let textLabel = self.textLabel, let detailTextLabel = self.detailTextLabel {
            textLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
            textLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true

            detailTextLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor).isActive = true
            detailTextLabel.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true

            textLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow:
                contentView.layoutMarginsGuide.topAnchor, multiplier: 1).isActive = true
            detailTextLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow:
                textLabel.lastBaselineAnchor, multiplier: 1).isActive = true

            contentView.rightAnchor.constraint(equalTo: self.rightAnchor)
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor)
            contentView.topAnchor.constraint(equalTo: self.topAnchor)
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
