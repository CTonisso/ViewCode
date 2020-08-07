//
//  AudioUtils.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/22/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import AVFoundation

class AudioUtils: NSObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    let audioSession: AVAudioSession = AVAudioSession.sharedInstance()

    func play(url: URL) {
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback,
                                         mode: .spokenAudio,
                                         options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("LOG: audioSession error: \(error.localizedDescription)")
        }

        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url, fileTypeHint: ".caf")
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch let error as NSError {
            print("LOG: audioPlayer error: \(error.localizedDescription)")
        }
    }

    func startRecording() {
        audioSession.requestRecordPermission { [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    self.start()
                } else {
                    print("LOG: Permission of microphone denied by user.")
                }
            }
        }
    }

    private func start() {
        do {
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                         mode: .spokenAudio,
                                         options: .defaultToSpeaker)
        } catch let error as NSError {
            print("LOG: audioSession error: \(error.localizedDescription)")
        }

        let soundFileURL = getAudio()

        let recordSettings: [String: Any] =
            [AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0]

        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings as [String: AnyObject])
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        } catch let error as NSError {
            print("LOG: audioRecorder error: \(error.localizedDescription)")
        }
    }

    func stopRecording() -> URL? {
        var audioUrl: URL?

        switch audioSession.recordPermission {
        case AVAudioSession.RecordPermission.granted:
            print("LOG: Audio session record permission granted.")
            audioUrl = self.stop()
        case AVAudioSession.RecordPermission.denied:
            print("LOG: Audio session record permission denied.")
        case AVAudioSession.RecordPermission.undetermined:
            print("LOG: Audio session record permission undetermined")
        }

        return audioUrl
    }

    private func stop() -> URL {
        audioPlayer?.stop()
        audioRecorder?.stop()

        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("LOG: audioSession error: \(error.localizedDescription)")
        }

        return getAudio()
    }

    func getAudio() -> URL {
        let dirPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return dirPaths[0].appendingPathComponent("audio.caf")
    }

    func playAudio(data: Data?, withDelegate delegate: AVAudioPlayerDelegate) {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        var audioPlayer: AVAudioPlayer?
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
                audioPlayer?.play()
            } catch let error as NSError {
                print("LOG: audioPlayer error: \(error.localizedDescription)")
            }
        }
    }

    func duration(url: URL) -> TimeInterval {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
        } catch let error as NSError {
            print("LOG: audioPlayer error: \(error.localizedDescription)")
        }

        return audioPlayer!.duration
    }

    func duration(data: Data) -> Double {
        do {
            try audioPlayer = AVAudioPlayer(data: data)
        } catch let error as NSError {
            print("LOG: audioPlayer error: \(error.localizedDescription)")
        }

        return audioPlayer!.duration
    }
}
