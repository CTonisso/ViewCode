//
//  PresentingAudioCollectionViewCell.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 10/24/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

protocol ShowViewControllerDelegate: NSObjectProtocol {
    func show(_ viewController: ChatLogController)
}

class PresentingAudioCollectionViewCell: UICollectionViewCell {
    let explorePresenter: ExplorePresenter =  ExplorePresenter()

    let theme: Theme = UserDefaultsManager.getTheme()
    let gradient = CAGradientLayer().backgroundGradientColor()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var startChatButton: UIButton!
    @IBOutlet weak var audioCurrentTimeLabel: UILabel!
    @IBOutlet weak var audioTimeLabel: UILabel!
    @IBOutlet weak var background: UIView!
    
    var user: LocalUser?

    weak var delegate: ShowViewControllerDelegate?
    
    var timer: Timer = Timer()
    var counter: Int = 0
    var duration: Int = 0
    var isPlaying: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
//        setupInitialState()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
//        setupInitialState()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupContentViewAppearence()
    }

    func setup() {
        explorePresenter.delegate = self
    }

    func setupInitialState() {
        setupLabelsAppearence()
        playButton.setBackgroundImage(theme.playButton, for: .normal)
        setupStartChatButtonAppearence()
    }

    func setupContentViewAppearence() {
        gradient.frame = self.background.bounds
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 27
        self.background.layer.cornerRadius = 13
        self.background.backgroundColor = .clear
        self.startChatButton.setTitleColor(theme.exploreButtonTitleColor, for: .normal)
        
        if theme is LightTheme {
            self.background.layer.insertSublayer(gradient, at: 0)
        } else {
            let pathWithRadius = UIBezierPath(roundedRect: self.background.bounds,
                                              byRoundingCorners: [.allCorners],
                                              cornerRadii: CGSize(width: 13.0, height: 13.0))
            let shape = CAShapeLayer()
            shape.lineWidth = 14
            shape.path = pathWithRadius.cgPath
            shape.strokeColor = UIColor.black.cgColor
            shape.fillColor = UIColor.clear.cgColor
            
            self.gradient.mask = shape
            self.background.layer.addSublayer(self.gradient)
        }
    }
    
    func setupLabelsAppearence() {
        nameLabel.font = UIFont(name: "Stilu-Bold", size: 20)
        ageLabel.font = UIFont(name: "Stilu-Bold", size: 20)
        cityLabel.font = UIFont(name: "Stilu-Bold", size: 20)
        audioTimeLabel.font = UIFont(name: "Stilu-Bold", size: 20)
        audioCurrentTimeLabel.font = UIFont(name: "Stilu-Bold", size: 20)
        
        nameLabel.textColor = theme.exploreLabelsColor
        ageLabel.textColor = theme.exploreLabelsColor
        cityLabel.textColor = theme.exploreLabelsColor
        audioTimeLabel.textColor = theme.exploreLabelsColor
        audioCurrentTimeLabel.textColor = theme.exploreLabelsColor
    }
    
    func setupPlayPauseButtonAppearence(isPlaying: Bool) {
        if isPlaying {
            playButton.setBackgroundImage(theme.pauseButton, for: .normal)
        } else {
            playButton.setBackgroundImage(theme.playButton, for: .normal)
        }
    }
    
    func setupStartChatButtonAppearence() {
        startChatButton.backgroundColor = theme.exploreButtonColor
        startChatButton.titleLabel?.font = UIFont(name: "Stilu-Bold", size: 24)
        startChatButton.titleLabel?.textColor = theme.exploreButtonTitleColor
        startChatButton.layer.cornerRadius = 9
    }
    
    @IBAction func playAudioDescription(_ sender: UIButton) {
        self.isPlaying = !self.isPlaying
        
        guard let descriptionID = user?.descriptionID else { return }
        
        if isPlaying == true {
            explorePresenter.playDescription(uuidString: descriptionID) { (data) in
                if let data = data {
                    self.duration = self.resetDuration(data)
                    self.audioTimeLabel.text = TimeFormat.format(seconds: self.duration)
                }
            }
            
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(PresentingAudioCollectionViewCell.updateCounter),
                                         userInfo: nil,
                                         repeats: true)
        } else {
            explorePresenter.pauseDescription()
            timer.invalidate()
        }
        setupPlayPauseButtonAppearence(isPlaying: self.isPlaying)
    }
    
    @objc func updateCounter() {
        counter += 1
        
        if counter > duration {
            timer.invalidate()
            counter = 0
        }
        
        self.audioCurrentTimeLabel.text = TimeFormat.format(seconds: counter)
    }
    
    func resetDuration(_ data: Data) -> Int {
        let duration = explorePresenter.duration(data: data)
        return Int(round(duration))
    }

    func setPlayButtonAccessibilityLabel() {
        let minutes = duration/60
        let seconds = duration%60
        playButton.accessibilityLabel = "Ouvir descrição com duração de \(minutes) minutos e \(seconds) segundos"

    }
    
    @IBAction func startChat(_ sender: UIButton) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        delegate?.show(chatLogController)
    }
}

extension PresentingAudioCollectionViewCell: ExplorePresenterDelegate {
    func audioPlayerDidFinishPlaying() {
        setupPlayPauseButtonAppearence(isPlaying: false)
    }
}
