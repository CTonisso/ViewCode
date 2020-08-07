//
//  ConfirmDescriptionViewController.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/22/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class ConfirmDescriptionViewController: ACViewController {
    let confirmDescriptionPresenter = ConfirmDescriptionPresenter()

    let theme: Theme = UserDefaultsManager.getTheme()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var recordAgainButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var recordAgainLabel: UILabel!
    @IBOutlet weak var progressBarBackground: UIView!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var progressBarTrailing: NSLayoutConstraint!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let gradient = CAGradientLayer().backgroundGradientColor()

    var user: LocalUser! = nil
    var audioUrl: URL! = nil

    var timer: Timer = Timer()
    var counter: Int = 0
    var duration: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = user.name

        duration = Int(confirmDescriptionPresenter.duration(url: audioUrl))
        durationLabel.text = TimeFormat.format(seconds: duration)

        setTheme()
        setupCardView()
    }

    private func setTheme() {
        self.view.backgroundColor = theme.backgroundColor

        nameLabel.textColor = theme.exploreLabelsColor
        nameLabel.font = UIFont(name: "Stilu-bold", size: 24)

        counterLabel.textColor = theme.exploreLabelsColor
        counterLabel.font = UIFont(name: "Stilu-bold", size: 24)

        durationLabel.textColor = theme.exploreLabelsColor
        durationLabel.font = UIFont(name: "Stilu-bold", size: 24)

        progressBarBackground.layer.cornerRadius = 11.5
        progressBar.layer.cornerRadius = 8.5
        progressBar.backgroundColor = theme.confirmRecordProgressBarColor

        saveButton.backgroundColor = theme.confirmRecordButtonColor
        saveButton.setTitleColor(theme.confirmRecordButtonTitleColor, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Stilu-bold", size: 24)

        separatorView.backgroundColor = theme.confirmRecordSeparatorColor

        recordAgainLabel.textColor = theme.confirmRecordLabelsColor
        recordAgainLabel.font = UIFont(name: "Stilu-bold", size: 24)
        
        playPauseButton.setImage(theme.playButton, for: .normal)
        redoButton.setImage(theme.redoButton, for: .normal)
    }

    func setupCardView() {
        gradient.frame = cardView.bounds

        cardView.backgroundColor = .clear
        cardView.layer.cornerRadius = 13

        if theme is LightTheme {

            cardView.layer.insertSublayer(gradient, at: 0)

        } else {

            let pathWithRadius = UIBezierPath(roundedRect: self.cardView.bounds,
                                              byRoundingCorners: [.allCorners],
                                              cornerRadii: CGSize(width: 13.0, height: 13.0))
            let shape = CAShapeLayer()
            shape.lineWidth = 14
            shape.path = pathWithRadius.cgPath
            shape.strokeColor = UIColor.black.cgColor
            shape.fillColor = UIColor.clear.cgColor

            self.gradient.mask = shape
            self.cardView.layer.addSublayer(self.gradient)

        }

    }

    @IBAction func listenDescription(_ sender: UIButton) {
        confirmDescriptionPresenter.playAudio(url: audioUrl)

        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(ConfirmDescriptionViewController.updateCounter),
                                     userInfo: nil,
                                     repeats: true)

        self.progressBarTrailing.constant = 3

        UIView.animate(withDuration: 5) {
            self.progressBar.layoutIfNeeded()
        }

        playPauseButton.setImage(theme.pauseButton, for: .normal)
    }

    @objc func updateCounter() {
        counter += 1

        if counter > duration {
            timer.invalidate()
            counter = 0
            playPauseButton.setImage(theme.playButton, for: .normal)
        }

        counterLabel.text = TimeFormat.format(seconds: counter)
    }
    
    func push(viewController: UIViewController) {
        guard let appDelegate = appDelegate,
            let appDelegateWindow = appDelegate.window,
            let appDelegateView = appDelegateWindow.rootViewController?.view,
            let viewContollersView = viewController.view else {
                return
        }
        
        viewContollersView.frame = appDelegateWindow.bounds
        appDelegateWindow.addSubview(viewContollersView)
        
        let transition = CATransition()
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = .reveal
        transition.subtype = .fromTop
        transition.duration = 0.45
        appDelegateView.layer.add(transition, forKey: "transition")
        viewContollersView.layer.add(transition, forKey: "transition")
        appDelegateView.isHidden = true
        viewContollersView.isHidden = false
        appDelegateWindow.rootViewController = viewController
        
        appDelegateWindow.makeKeyAndVisible()
    }

    @IBAction func saveDescription(_ sender: UIButton) {
        confirmDescriptionPresenter.saveAudio()
        
        guard let appDelegate = appDelegate else { return }
        self.dismiss(animated: true, completion: nil)
        push(viewController: appDelegate.initialTabBarController())
    }

    @IBAction func recordAgain(_ sender: UIButton) {
        performSegue(withIdentifier: "RecordDescription", sender: self)
    }
}
