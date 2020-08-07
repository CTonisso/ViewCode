//
//  AudioCell.swift
//  AccessibilityChat
//
//  Created by Bianca Itiroko on 22/10/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import UIKit

protocol AudioCellDelegate: class {
    func playAudio(withData data: Data?, from cell: AudioCellProtocol)
    func pauseAudio(from cell: AudioCellProtocol)
}

class AudioCell: UICollectionViewCell {
//    @IBOutlet weak var bubbleView: UIView!
//    @IBOutlet weak var playPauseButton: PlayPauseButton!
//    @IBOutlet weak var progressView: UIProgressView!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//
//    static let blueColor = UIColor(red: 0, green: 137, blue: 249)
//    var audioData: Data?
//    var url: URL?
//    var progressViewCurrentTime = 0.0
//    weak var delegate: AudioCellDelegate? {
//        didSet {
//            activityIndicator.isHidden = true
//            activityIndicator.stopAnimating()
//            playPauseButton.isHidden = false
//        }
//    }
//
//    var bubbleWidthAnchor: NSLayoutConstraint?
//    var bubbleViewRightAnchor: NSLayoutConstraint?
//    var bubbleViewLeftAnchor: NSLayoutConstraint?
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        configureBubbleView()
//        configurePlayButton()
//        configureProgressView()
//        configureWaitForAudioData()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    private func configureWaitForAudioData() {
//        activityIndicator.isHidden = false
//        activityIndicator.startAnimating()
//        playPauseButton.isHidden = true
//    }
//
//    private func configureProgressView() {
//        progressView.transform = progressView.transform.scaledBy(x: 1, y: bubbleView.bounds.height)
//        progressView.progressTintColor = AudioCell.blueColor
//    }
//
//    func configureBubbleView() {
//        bubbleView.backgroundColor = .white
//        bubbleView.translatesAutoresizingMaskIntoConstraints = false
//        bubbleView.layer.cornerRadius = 16
//        bubbleView.layer.masksToBounds = true
//        bubbleView.isUserInteractionEnabled = true
//
//        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
//        bubbleViewRightAnchor?.isActive = true
//        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
//        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
//        bubbleWidthAnchor?.isActive = true
//        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//    }
//
////    func configureTimeLabel() {
////        timeLabel.leftAnchor.constraint(equalTo: playButton.rightAnchor).isActive = true
////        timeLabel.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
////        timeLabel.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
////        timeLabel.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
////    }
//
//    func configurePlayButton() {
//        playPauseButton.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
//        playPauseButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
//        playPauseButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        playPauseButton.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
//
//        if playPauseButton.isPlaying {
////            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
//            playPauseButton.setTitle("Pause", for: .normal)
//        } else {
//            playPauseButton.setImage(UIImage(named: "play_white"), for: .normal)
//            playPauseButton.setTitle("Play", for: .normal)
//        }
//    }
//
//    @IBAction func playButtonPressed(_ sender: Any) {
//        playPauseButton.isPlaying = !playPauseButton.isPlaying
//        if playPauseButton.isPlaying {
//            playPauseButton.setTitle("Pause", for: .normal)
//            delegate?.playAudio(withData: audioData, from: self)
//        } else {
//            playPauseButton.setTitle("Play", for: .normal)
//            delegate?.pauseAudio(from: self)
//        }
//    }
}

//extension AudioCell: ProgressBarDelegate {
//    func setProgressInProgressBar(with progress: Float) {
//        progressView.setProgress(progress, animated: false)
//    }
//}
//
//extension AudioCell: PlayPauseButtonDelegate {
//    func audioPlayerDidFinish() {
//        progressView.progress = 0.0
//        progressViewCurrentTime = 0.0
//        playPauseButton.isPlaying = !playPauseButton.isPlaying
//        if playPauseButton.isPlaying {
//            playPauseButton.setTitle("Pause", for: .normal)
//        } else {
//            playPauseButton.setTitle("Play", for: .normal)
//        }
//    }
//}
