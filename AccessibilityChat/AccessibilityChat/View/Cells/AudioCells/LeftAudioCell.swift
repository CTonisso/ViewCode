//
//  ChatMessageCell.swift
//  gameofchats
//
//  Created by Brian Voong on 7/12/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Cartography

class LeftAudioCell: UICollectionViewCell, AudioCellProtocol {
    let blueColor = UIColor(red: 0, green: 137, blue: 249)
    let theme: Theme = UserDefaultsManager.getTheme()

    lazy var bubbleImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isAccessibilityElement = false
        return view
    }()

    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .clear
        progressView.backgroundColor = .clear
        progressView.isAccessibilityElement = false
        return progressView
    }()

    var playPauseButton: PlayPauseButton = {
        let button = PlayPauseButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isAccessibilityElement = false
        button.accessibilityTraits = UIAccessibilityTraits.none
        button.accessibilityLabel = "Ouvir áudio"
        button.accessibilityHint = "Clique duas vezes para tocar o áudio"
        return button
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.isAccessibilityElement = false
        return activity
    }()

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.isAccessibilityElement = true
        return label
    }()

    var audioData: Data?
    var url: URL?
    var progressViewCurrentTime = 0.0
    weak var delegate: AudioCellDelegate? {
        didSet {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            playPauseButton.isHidden = false
        }
    }
    var senderName: String = ""

    let playAsset = UserDefaultsManager.getTheme().playLeftButton
    let pauseAsset = UserDefaultsManager.getTheme().pauseLeftButton

    fileprivate func setupInitialState() {
        self.contentView.addSubview(bubbleImageView)
        self.contentView.addSubview(activityIndicator)
        self.contentView.addSubview(progressView)
        self.contentView.addSubview(playPauseButton)
        self.contentView.addSubview(timeLabel)
        configureTheme()
        configurePlayButton()
        configureConstraints()
        configureWaitForAudioData()
        self.isAccessibilityElement = true
        self.shouldGroupAccessibilityChildren = true
        self.accessibilityTraits = UIAccessibilityTraits.startsMediaSession
    }

    func configureTheme() {
        let theme = UserDefaultsManager.getTheme()
        activityIndicator.color = theme.leftBalloonTextColor
        timeLabel.textColor = theme.leftAudioBalloonTextColor
        progressView.progressImage = theme.leftBalloonFill
        bubbleImageView.image = theme.leftBalloon
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.shouldGroupAccessibilityChildren = true
        setupInitialState()
    }

    func configurePlayButton() {
        playPauseButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)

        if playPauseButton.isPlaying {
            playPauseButton.setImage(pauseAsset, for: .normal)
//            playPauseButton.setTitle("Pause", for: .normal)
        } else {
            playPauseButton.setImage(playAsset, for: .normal)
//            playPauseButton.setTitle("Play", for: .normal)
        }
    }

    private func configureWaitForAudioData() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        playPauseButton.isHidden = true
    }

    @objc func playButtonPressed(_ sender: Any) {
        playPauseButton.isPlaying = !playPauseButton.isPlaying
        if playPauseButton.isPlaying {
            playPauseButton.setImage(pauseAsset, for: .normal)
//            playPauseButton.setTitle("Pause", for: .normal)
            delegate?.playAudio(withData: audioData, from: self)
        } else {
            playPauseButton.setImage(playAsset, for: .normal)
//            playPauseButton.setTitle("Play", for: .normal)
            delegate?.pauseAudio(from: self)
        }
    }
    
    func configureConstraints() {
        constrain(bubbleImageView,
                  playPauseButton,
                  activityIndicator,
                  progressView,
                  timeLabel) { (bubble, button, activity, progress, timeLabel) in
            guard let superview = bubble.superview else { return }
            bubble.left == superview.left + 10
            bubble.bottom == superview.bottom
            bubble.right == superview.right - 150
            bubble.top == superview.top

            button.right == bubble.right + 14
            button.centerY == bubble.centerY
            button.width == 80
            button.height == bubble.height

            progress.centerY == bubble.centerY
            progress.trailing == button.trailing - 10
            progress.leading == bubble.leading
            progress.height == bubble.height

            activity.centerY == button.centerY
            activity.centerX == button.centerX
            activity.width == button.width
            activity.height == button.height

            timeLabel.centerY == bubble.centerY
            timeLabel.leading == bubble.leading + 20
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LeftAudioCell: ProgressBarDelegate {
    func setProgressInProgressBar(with progress: Float) {
        progressView.setProgress(progress, animated: false)
    }
}

extension LeftAudioCell: PlayPauseButtonDelegate {
    func audioPlayerDidFinish() {
        progressView.progress = 0.0
        progressViewCurrentTime = 0.0
        playPauseButton.isPlaying = !playPauseButton.isPlaying
        if playPauseButton.isPlaying {
            playPauseButton.setImage(pauseAsset, for: .normal)
//            playPauseButton.setTitle("Pause", for: .normal)
        } else {
            playPauseButton.setImage(playAsset, for: .normal)
//            playPauseButton.setTitle("Play", for: .normal)
        }
    }
}
