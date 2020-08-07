//
//  RightAudioCell.swift
//  AccessibilityChat
//
//  Created by Bianca Itiroko on 07/11/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Cartography

class RightAudioCell: UICollectionViewCell, AudioCellProtocol {
    let mainColor = UIColor(red: 98, green: 66, blue: 248)
    let theme: Theme = UserDefaultsManager.getTheme()

    lazy var bubbleImageView: UIImageView = {
        let view = UIImageView()
        view.image = theme.rightBalloon
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isAccessibilityElement = false
        return view
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .clear
        progressView.backgroundColor = theme.backgroundColor
        progressView.progressImage = theme.rightBalloonFill
        progressView.isAccessibilityElement = false
        return progressView
    }()
    
    var playPauseButton: PlayPauseButton = {
        let button = PlayPauseButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isAccessibilityElement = true
        button.accessibilityTraits = UIAccessibilityTraits.none
        button.accessibilityLabel = "Ouvir áudio"
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.color = theme.rightBalloonTextColor
        activity.isAccessibilityElement = false
        return activity
    }()

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = theme.rightAudioBalloonTextColor
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
    let playAsset = UserDefaultsManager.getTheme().playRightButton
    let pauseAsset = UserDefaultsManager.getTheme().pauseRightButton
    
    fileprivate func setupInitialState() {
        self.contentView.addSubview(progressView)
        self.contentView.addSubview(bubbleImageView)
        self.contentView.addSubview(playPauseButton)
        self.contentView.addSubview(activityIndicator)
        self.contentView.addSubview(timeLabel)
        configureTheme()
        configurePlayButton()
        configureConstraints()
        configureWaitForAudioData()
        self.isAccessibilityElement = true
        self.accessibilityElements = [playPauseButton]
        self.shouldGroupAccessibilityChildren = true
        self.accessibilityTraits = UIAccessibilityTraits.startsMediaSession
    }

    func configureTheme() {
        let theme = UserDefaultsManager.getTheme()
        backgroundColor = .clear
        timeLabel.textColor = theme.recordTitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            bubble.left == superview.left + 150
            bubble.bottom == superview.bottom
            bubble.right == superview.right - 10
            bubble.top == superview.top
            
            button.left == bubble.left - 14
            button.centerY == bubble.centerY
            button.width == 80
            button.height == bubble.height
            
            progress.centerY == bubble.centerY
            progress.trailing == bubble.trailing - 10
            progress.leading == bubble.leading
            progress.height == bubble.height
            
            activity.centerY == button.centerY
            activity.centerX == button.centerX
            activity.width == button.width
            activity.height == button.height

            timeLabel.centerY == bubble.centerY
            timeLabel.trailing == bubble.trailing - 20
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RightAudioCell: ProgressBarDelegate {
    func setProgressInProgressBar(with progress: Float) {
        progressView.setProgress(progress, animated: false)
    }
}

extension RightAudioCell: PlayPauseButtonDelegate {
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
