//
//  ChatMessageCell.swift
//  gameofchats
//
//  Created by Brian Voong on 7/12/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Cartography

class LeftMessageCell: UICollectionViewCell {
    let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "SAMPLE TEXT FOR NOW"
//        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = UIColor.clear
        textLabel.adjustsFontForContentSizeCategory = true
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.numberOfLines = 0
        return textLabel
    }()

    static let blueColor = UIColor(red: 0, green: 137, blue: 249)

    let bubbleImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    var timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(textLabel)
        self.contentView.addSubview(timeLabel)
        configureTheme()
        configureConstraints()
        self.isAccessibilityElement = true
        self.shouldGroupAccessibilityChildren = true
    }

    func configureTheme() {
        let theme = UserDefaultsManager.getTheme()
        textLabel.textColor = theme.leftBalloonTextColor
        bubbleImageView.backgroundColor = theme.backgroundColor
        bubbleImageView.image = theme.leftBalloon
        timeLabel.textColor = theme.leftBalloonTextColor
    }

    func configureConstraints() {
        constrain(bubbleImageView, textLabel, timeLabel) { (bubble, text, timeLabel) in
            guard let superview = bubble.superview else { return }
            bubble.left == superview.left + 10
            bubble.bottom == superview.bottom
            bubble.right == superview.right - 100
            bubble.top == superview.top

            timeLabel.centerY == bubble.centerY
            timeLabel.leading == bubble.leading + 20
            timeLabel.width >= 40

            text.top == bubble.top + 15
            text.bottom == bubble.bottom - 15
            text.left == timeLabel.right + 20  ~ LayoutPriority(750)
            text.right == bubble.right - 20
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
