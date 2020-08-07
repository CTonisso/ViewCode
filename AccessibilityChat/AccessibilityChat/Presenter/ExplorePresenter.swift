//
//  ExplorePresenter.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 10/25/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

protocol ExplorePresenterDelegate: NSObjectProtocol {
    func audioPlayerDidFinishPlaying()
}

class ExplorePresenter: NSObject {
    let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    var audioPlayer: AVAudioPlayer?

    weak var delegate: ExplorePresenterDelegate?
    
    let audioUtils: AudioUtils = AudioUtils()

    func fetchUser() -> String? {
        let userServices = UserServices()

        return userServices.userUid()
    }

    func fetchUsers(without userUid: String, completion: @escaping ([LocalUser]) -> Void) {
        let userServices = UserServices()

        userServices.fetchAllUsers(without: userUid) { (users) in
            completion(users)
        }
    }

    func retrieveAudioDescriptions(users: [LocalUser], completion: @escaping (_ datas: [Data?]) -> Void) {
        let audioServices = AudioServices()

        let uuids = users.map {
            $0.descriptionID
        }

        audioServices.retrieveAudioDescriptions(uuids: uuids) { (audios) in
            completion(audios)
        }
    }

    func playDescription(uuidString: String, completion: @escaping (Data?) -> Void) {
        let audioServices: AudioServices = AudioServices()

        if let uuid = UUID(uuidString: uuidString) {
            audioServices.retrieveAudioDescription(uuid: uuid, completion: { (data, error) in
                if error != nil {
                    print("LOG: \(error!.localizedDescription)")
                } else {
                    self.playAudioDescription(data: data)
                    self.setupCommandCenter()
                    completion(data)
                }
            })
        }
    }
    
    func pauseDescription() {
        audioPlayer?.pause()
    }

    private func setupCommandCenter() {
        // Atualiza o "Now Playing" no command center com o nome escolhido
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: "Accessibility"]

        // Inicia o controle remoto do command center (para possibilitar o toque com dois dedos)
        UIApplication.shared.beginReceivingRemoteControlEvents()

        // Instância do command center
        let commandCenter = MPRemoteCommandCenter.shared()

        // Configura os comandos do command center
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.isEnabled = true

        commandCenter.playCommand.addTarget { [weak self] (_) -> MPRemoteCommandHandlerStatus in
            self?.audioPlayer!.play()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] (_) -> MPRemoteCommandHandlerStatus in
            self?.audioPlayer!.pause()
            return .success
        }
        commandCenter.togglePlayPauseCommand.addTarget { [weak self] (_) -> MPRemoteCommandHandlerStatus in
            guard let isPlaying = self?.audioPlayer!.isPlaying else {
                return .noActionableNowPlayingItem
            }

            if isPlaying {
                self?.audioPlayer!.pause()
            } else {
                self?.audioPlayer!.play()
            }

            return .success
        }
    }

    func duration(data: Data) -> TimeInterval {
        return audioUtils.duration(data: data)
    }
}

extension ExplorePresenter: AVAudioPlayerDelegate {
    func playAudioDescription(data: Data?) {
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
                try audioPlayer = AVAudioPlayer(data: data)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("LOG: audioPlayer error: \(error.localizedDescription)")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let audioPlayerDidFinishPlaying =  self.delegate?.audioPlayerDidFinishPlaying {
            audioPlayerDidFinishPlaying()
        }
    }
}
