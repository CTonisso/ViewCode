//
//  RecordDescriptionViewController.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/17/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import AVFoundation

class RecordDescriptionViewController: ACViewController {
    let recordDescriptionPresenter = RecordDescriptionPresenter()
    let theme: Theme = UserDefaultsManager.getTheme()
    var isRecording: Bool = false
    var timer: Timer = Timer()
    var counter: Int = 0
    let gradient = CAGradientLayer().backgroundGradientColor()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var user: LocalUser!
    var audioUrl: URL?

    let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        setTheme()
        setupRecordingButtonAppearence()

        // request permission of microphone
        audioSession.requestRecordPermission { _ in }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        recordDescriptionPresenter.fetchUser(completion: { (localUser) in
            self.user = localUser
        })

        self.recordButton.setTitle("Gravar \n\(TimeFormat.format(seconds: self.counter))", for: .normal)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destiny = segue.destination as? ConfirmDescriptionViewController, let audioUrl = audioUrl {
            destiny.user = user
            destiny.audioUrl = audioUrl
        }
    }

    private func setTheme() {
        self.view.backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.recordTitleColor
        detailLabel.textColor = theme.recordDescriptionColor
        cancelButton.backgroundColor = theme.recordCancelButtonColor
        cancelButton.setTitleColor(theme.recordCancelButtonTitleColor, for: .normal)
        cancelButton.layer.cornerRadius = 13
    }

    private func setupRecordingButtonAppearence() {
        recordButton.titleLabel?.font = UIFont(name: "Stilu-bold", size: 42)
        recordButton.titleLabel?.textAlignment = .center
        recordButton.backgroundColor = .clear

        if isRecording {
            UIView.animate(withDuration: 0.5, animations: {
                self.recordButton.layer.cornerRadius = 13
                self.recordButton.setTitleColor(self.theme.recordPauseButtonTitleColor, for: .normal)

                let pathWithRadius = UIBezierPath(roundedRect: self.recordButton.bounds,
                                                  byRoundingCorners: [.allCorners],
                                                  cornerRadii: CGSize(width: 13.0, height: 13.0))
                let shape = CAShapeLayer()
                shape.lineWidth = 14
                shape.path = pathWithRadius.cgPath
                shape.strokeColor = UIColor.black.cgColor
                shape.fillColor = UIColor.clear.cgColor

                self.gradient.mask = shape
                self.recordButton.layer.addSublayer(self.gradient)
            })
        } else {
            self.gradient.mask = nil
            self.gradient.frame = self.recordButton.bounds
            self.recordButton.layer.insertSublayer(self.gradient, at: 0)
            self.recordButton.setTitleColor(self.theme.recordButtonTitleColor, for: .normal)
            self.recordButton.layer.cornerRadius = self.recordButton.frame.height / 2
        }
    }

    @IBAction func touchUpInside(_ sender: UIButton) {
        if isRecording {
            isRecording = !isRecording
            self.audioUrl = recordDescriptionPresenter.stopRecording()
            self.timer.invalidate()
            performSegue(withIdentifier: "ConfirmDescription", sender: self)
        } else {
            isRecording = !isRecording
            recordDescriptionPresenter.startRecording()
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(RecordDescriptionViewController.updateCounter),
                                         userInfo: nil,
                                         repeats: true)
        }
        setupRecordingButtonAppearence()
    }

    @objc func updateCounter() {
        self.counter += 1
        self.recordButton.setTitle("Pausar \n\(TimeFormat.format(seconds: self.counter))", for: .normal)
        setupRecordingButtonAppearence()
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        // TODO: push to what????
//        push(viewController: LoginController())
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
}
