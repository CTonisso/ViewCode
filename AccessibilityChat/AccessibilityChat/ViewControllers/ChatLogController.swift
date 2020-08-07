//
//  ChatLogController.swift
//  gameofchats
//
//  Created by Brian Voong on 7/7/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import AudioToolbox

protocol ChatLogDelegate: class {
    func returnToChatLog()
}

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    let chatLogPresenter = ChatLogPresenter()
    let theme: Theme = UserDefaultsManager.getTheme()
    var user: LocalUser? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }

    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.tintColor = theme.inputTextFieldTintColor
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = theme.configTitleColor
        return containerView
    }()

    var messages = [Message]()
    var audioPlayer: AVAudioPlayer?
    weak var progressBarDelegate: ProgressBarDelegate?
    weak var playPauseCellButtonDelegate: PlayPauseButtonDelegate?
    var timer: Timer?
    var audiosDict: [String: Data] = [:]

    func observeMessages() {
        guard let user = user else { return }
        chatLogPresenter.fetchMessages(toUser: user) { (messages) in
            self.messages = messages
            self.collectionView.reloadData()
        }
    }

    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.textColor = theme.inputTextFieldTintColor
        let color = theme.inputTextFieldTintColor
        textField.attributedPlaceholder = NSAttributedString(string: "Digite sua mensagem...",
                                                             attributes: [NSAttributedString.Key.foregroundColor:
                                                                color.withAlphaComponent(0.3)])
        return textField
    }()

    var shouldShowSendAudioButton: Bool = true {
        didSet {
            sendButton.removeTarget(nil, action: nil, for: .allEvents)
            if shouldShowSendAudioButton {
                sendButton.accessibilityLabel = "Clique duas vezes e segure para enviar um áudio"
                sendButton.setImage(theme.micImage, for: .normal)
                sendButton.addTarget(self, action: #selector(touchDownSendAudioButton), for: .touchDown)
                sendButton.addTarget(self, action: #selector(touchUpInsideSendAudioButton), for: .touchUpInside)
            } else {
                sendButton.setImage(theme.sendImage, for: .normal)
                sendButton.accessibilityLabel = "Enviar mensagem"
                sendButton.addTarget(self, action: #selector(handleSendText), for: .touchUpInside)
            }
        }
    }

    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(theme.micImage, for: .normal)
        return button
    }()

    let rightCellId = "rightCellId"
    let leftCellId = "leftCellId"
    let audioCellID = "audioCellId"
    let leftAudioCellId = "leftAudioCellId"
    let rightAudioCellId = "rightAudioCellId"
    let audioUtil = AudioUtils()
    let audioService = AudioServices()

    override func viewDidLoad() {
        super.viewDidLoad()
        shouldShowSendAudioButton = true
//        collectionView?.contentInset = UIEdgeInsets(top: (navigationController?.navigationBar.frame.size.height ?? 8), left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = theme.backgroundColor
        collectionView?.register(LeftMessageCell.self, forCellWithReuseIdentifier: leftCellId)
        collectionView?.register(RightMessageCell.self, forCellWithReuseIdentifier: rightCellId)
        collectionView?.register(LeftAudioCell.self, forCellWithReuseIdentifier: leftAudioCellId)
        collectionView?.register(RightAudioCell.self, forCellWithReuseIdentifier: rightAudioCellId)
        collectionView.register(UINib(nibName: "AudioCell", bundle: nil), forCellWithReuseIdentifier: audioCellID)
        collectionView?.keyboardDismissMode = .interactive
        self.navigationController?.navigationBar.barStyle = theme.navigationBarStyle
        setupKeyboardObservers()
        self.hideKeyboardWhenTappedAround()
        
        let reportBarButtonItem = UIBarButtonItem(image: theme.reportImage.withRenderingMode(.alwaysOriginal),
                                                  style: .plain,
                                                  target: self, action: #selector(reportPressed))
        reportBarButtonItem.isAccessibilityElement = true
        reportBarButtonItem.accessibilityLabel = "Denunciar usuário"
        reportBarButtonItem.accessibilityTraits = UIAccessibilityTraits.button
        self.navigationItem.rightBarButtonItem = reportBarButtonItem
    }

    lazy var inputContainerView: UIView = {
        containerView.addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true

        containerView.addSubview(self.inputTextField)
        //x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true

        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        return containerView
    }()

    override var inputAccessoryView: UIView? {
        return inputContainerView
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func reportPressed() {
        guard let user = self.user else { return }
        let alert = ChooseReportModalView(user: user)
        alert.chatLogDelegate = self
        alert.show(animated: true)
        self.containerView.isHidden = true
        self.collectionView.isHidden = true
    }

    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name:
            UIResponder.keyboardDidShowNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as AnyObject).cgRectValue,
            let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
                as AnyObject).doubleValue else { return }
        collectionView?.contentInset = UIEdgeInsets(top: (navigationController?.navigationBar.frame.size.height ?? 8) + 80.0, left: 0, bottom: 8, right: 0)
        UIView.animate(withDuration: keyboardDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }

    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
            as AnyObject).doubleValue
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        shouldShowSendAudioButton = false
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    fileprivate func setAcessibilityHint(_ message: Message, _ label: UILabel) {
        let hourAndMinutes = message.sendTime?.split(separator: ":") ?? []
        if hourAndMinutes.isEmpty == false {
            label.accessibilityHint = "Mensagem enviada em \(hourAndMinutes[0]) e \(hourAndMinutes[1])"
        }
    }
    
    func instantiateRightMessageCell(message: Message, indexPath: IndexPath) -> RightMessageCell {
        //outgoing blue
        guard let rightCell = collectionView.dequeueReusableCell(withReuseIdentifier: rightCellId,
                                                                 for: indexPath) as? RightMessageCell
            else { return RightMessageCell() }
        rightCell.textLabel.text = message.text
        rightCell.timeLabel.text = message.sendTime
        rightCell.textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        rightCell.textLabel.adjustsFontForContentSizeCategory = true
        rightCell.accessibilityLabel = "Sua mensagem \(message.text ?? "") as \(message.sendTime ?? "")"
        return rightCell
    }

    func instantiateLeftMessageCell(message: Message, indexPath: IndexPath) -> LeftMessageCell {
        //incoming gray
        guard let leftCell = collectionView.dequeueReusableCell(withReuseIdentifier: leftCellId,
                                                                for: indexPath) as? LeftMessageCell
            else { return LeftMessageCell() }
        leftCell.textLabel.text = message.text
        leftCell.timeLabel.text = message.sendTime
        leftCell.textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        leftCell.accessibilityLabel = "Mensagem \(message.text ?? "") as \(message.sendTime ?? "")"
        leftCell.textLabel.adjustsFontForContentSizeCategory = true
        return leftCell
    }

    fileprivate func handleAudioMessage(_ message: Message, _ collectionView: UICollectionView,
                                        _ indexPath: IndexPath, _ audioMessageID: String,
                                        _ uuid: UUID) -> UICollectionViewCell {
        var audioCell: AudioCellProtocol
        if message.fromId == Auth.auth().currentUser?.uid {
            guard let rightAudioCell = collectionView.dequeueReusableCell(withReuseIdentifier: rightAudioCellId,
                                                                          for: indexPath) as? RightAudioCell
                else { return UICollectionViewCell() }
            rightAudioCell.accessibilityLabel = "Áudio enviado por você as \(message.sendTime ?? "")"
            rightAudioCell.accessibilityHint = "Clique duas vezes para tocar o áudio"

            audioCell = rightAudioCell
        } else {
            guard let leftAudioCell = collectionView.dequeueReusableCell(withReuseIdentifier: leftAudioCellId,
                                                                         for: indexPath) as? LeftAudioCell
                else { return UICollectionViewCell() }
            leftAudioCell.accessibilityLabel = "Áudio enviado por \(user?.name ?? "") as \(message.sendTime ?? "")"
            leftAudioCell.accessibilityHint = "Clique duas vezes para tocar o áudio"

            audioCell = leftAudioCell
        }
        
        if let audioData = audiosDict[audioMessageID] {
            // Audio has already been downloaded
            audioCell.audioData = audioData
            audioCell.delegate = self
            audioCell.timeLabel.text = message.sendTime
        } else {
            audioService.retrieveAudioMessage(uuid: uuid) { (data, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                }
                audioCell.audioData = data
                audioCell.delegate = self
                audioCell.timeLabel.text = message.sendTime
                self.audiosDict[audioMessageID] = data
            }
        }
        return audioCell as? UICollectionViewCell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let message = messages[indexPath.item]
        if let audioMessageID = message.audioMessageID,
            let uuid = UUID(uuidString: audioMessageID), audioMessageID != "" {
            return handleAudioMessage(message, collectionView, indexPath, audioMessageID, uuid)
        } else {
            if message.fromId == Auth.auth().currentUser?.uid {
                return instantiateRightMessageCell(message: message, indexPath: indexPath)
            } else {
                return instantiateLeftMessageCell(message: message, indexPath: indexPath)
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    fileprivate func setupCell(message: Message) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell = RightMessageCell()
        } else {
            //incoming gray
            cell = LeftMessageCell()
        }
        return cell
    }

    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        
        guard let info = notification.userInfo else {return}
        guard let keyboardFrameEndValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrameEnd = keyboardFrameEndValue.cgRectValue
        
        var itemSize = view.bounds.size
        itemSize.height = keyboardFrameEnd.origin.y
        
        guard let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        layout.itemSize = itemSize
        
        collectionView?.setCollectionViewLayout(layout, animated: true)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        var height: CGFloat = 50

        //get estimated height somehow????
        if let text = messages[indexPath.item].text, text != "" {
            height = estimateFrameForText(text).height + 80
        }

        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }

    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSString(string: text).boundingRect(with: size, options: options,
                                                   attributes: attributes,
                                                   context: nil)
    }

    var containerViewBottomAnchor: NSLayoutConstraint?

    func handleSend(audioMessageID: String? = nil) {
        guard let user = self.user,
            let message = self.inputTextField.text, (message != "" || audioMessageID != nil) else { return }
        chatLogPresenter.sendMessage(toUser: user, text: message, audioMessageID: audioMessageID)
        self.inputTextField.text = nil
        collectionView.scrollToLast()
    }

    func vibrateFeedback() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    @objc func handleSendText() {
        handleSend(audioMessageID: nil)
    }

    @objc func touchDownSendAudioButton() {
        vibrateFeedback()
        audioUtil.startRecording()
        print("Start recording")
    }

    @objc func touchUpInsideSendAudioButton() {
        guard let url = audioUtil.stopRecording() else { return }
        chatLogPresenter.sendAudioToStorage(url: url) { (audioID) in
            self.handleSend(audioMessageID: audioID)
        }
        vibrateFeedback()
        print("Stop recording")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend(audioMessageID: nil)
        textField.resignFirstResponder()
        return true
    }
}

extension ChatLogController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        inputTextField.resignFirstResponder()
        shouldShowSendAudioButton = true
        view.endEditing(true)
    }
}

extension UICollectionView {
    func scrollToLast() {
        guard numberOfSections > 0 else {
            return
        }

        let lastSection = numberOfSections - 1

        guard numberOfItems(inSection: lastSection) > 0 else {
            return
        }

        let lastItemIndexPath = IndexPath(item: numberOfItems(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
}

protocol ProgressBarDelegate: class {
    func setProgressInProgressBar(with progress: Float)
}

extension ChatLogController: AudioCellDelegate, AVAudioPlayerDelegate {
    func playAudio(withData data: Data?, from cell: AudioCellProtocol) {
        guard let audioData = data else { return }
        self.progressBarDelegate = cell
        self.playPauseCellButtonDelegate = cell
//        let cellIndexPath = collectionView.indexPath(for: cell)
//        cell.audioData = messages[cellIndexPath?.row ?? 0].audioData
        playAudio(data: audioData, withDelegate: self, from: cell.progressViewCurrentTime)
    }

    func pauseAudio(from cell: AudioCellProtocol) {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.pause()
        cell.progressViewCurrentTime = audioPlayer.currentTime
        timer?.invalidate()
    }

    func playAudio(data: Data?, withDelegate delegate: AVAudioPlayerDelegate, from time: TimeInterval) {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback,
                                         mode: .spokenAudio,
                                         options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("LOG: audioSession error: \(error.localizedDescription)")
        }
        if let data = data {
            do {
                try audioPlayer = AVAudioPlayer(data: data, fileTypeHint: ".caf")
                audioPlayer?.prepareToPlay()
                audioPlayer?.delegate = delegate
//                let playbackDelay = time
                audioPlayer?.play()
                startProgressBarTimer()
            } catch let error as NSError {
                print("LOG: audioPlayer error: \(error.localizedDescription)")
            }
        }
    }

    func startProgressBarTimer() {
        guard let audioPlayer = audioPlayer else { return }
        timer = Timer.scheduledTimer(timeInterval: 0.02,
                             target: self,
                             selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
        progressBarDelegate?.setProgressInProgressBar(with: Float(audioPlayer.currentTime/audioPlayer.duration))
    }

    @objc func updateAudioProgressView() {
        guard let audioPlayer = audioPlayer else { return }
        if audioPlayer.isPlaying {
            progressBarDelegate?.setProgressInProgressBar(with: Float(audioPlayer.currentTime/audioPlayer.duration))
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playPauseCellButtonDelegate?.audioPlayerDidFinish()
    }
}

protocol PlayPauseButtonDelegate: class {
    func audioPlayerDidFinish()
}

extension ChatLogController: ChatLogDelegate {
    func returnToChatLog() {
        self.containerView.isHidden = false
        self.collectionView.isHidden = false
    }
}
