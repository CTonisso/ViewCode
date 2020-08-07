//
//  AudioMessageCell.swift
//  AccessibilityChat
//
//  Created by Bianca Itiroko on 19/10/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class AudioMessageCell: UICollectionViewCell {
    static let blueColor = UIColor(red: 0, green: 137, blue: 249)

    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()

    let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(playButtonTouched), for: .touchUpInside)
        return button
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.isUserInteractionEnabled = false
        return label
    }()

    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.heightAnchor.constraint(equalToConstant: 400)

        addSubview(bubbleView)
        //x,y,w,h
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        addSubview(playButton)
        playButton.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        playButton.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true

        addSubview(timeLabel)
        timeLabel.leftAnchor.constraint(equalTo: playButton.rightAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func playButtonTouched() {
        print("Oi")
    }
}
