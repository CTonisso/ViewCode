//
//  AudioServices.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/16/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import AVFoundation

class AudioServices {
    let storageMechanism = StorageMechanism()
    let databaseMechanism = DatabaseMechanism()

    /// Upload audio description of the user to storage
    ///
    /// - Parameters:
    ///   - uuid: uuid of user
    ///   - url: url of the audio
    ///   - completion: handler for error
    func uploadAudioDescription(uuid: UUID, url: URL, completion: @escaping (_ error: Error?) -> Void) {
        let fileName: String = uuid.uuidString + ".caf"

        storageMechanism.uploadAudio(directory: "descriptions", fileName: fileName, url: url) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("LOG: Upload audio successful.")
            }
        }
    }

    /// Retrieve audio description of the user from storage firebase
    ///
    /// - Parameters:
    ///   - uuid: uuid of user
    ///   - completion: handler for data or error
    func retrieveAudioDescription(uuid: UUID, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        let fileName: String = uuid.uuidString + ".caf"

        storageMechanism.retrieveAudio(directory: "descriptions", fileName: fileName) { (data, error) in
            if error != nil {
                print("LOG: \(error!.localizedDescription)")
            } else {
                completion(data, error)
            }
        }
    }

    /// Retrieve all audio descriptions
    ///
    /// - Parameters:
    ///   - uuids: uuids of each description
    ///   - completion: data array containing the audio descriptions
    func retrieveAudioDescriptions(uuids: [String?], completion: @escaping (_ datas: [Data?]) -> Void) {
        var audios: [Data?] = []
        let group = DispatchGroup()

        for uuid in uuids {
            guard let uuid = uuid else { return }
            let fileName: String = uuid + ".caf"

            group.enter()
            storageMechanism.retrieveAudio(directory: "descriptions", fileName: fileName) { (data, error) in
                
                if error != nil {
                    print("LOG: \(error!.localizedDescription)")
                } else {
                    audios.append(data)
                    group.leave()
                    group.notify(queue: .main) {
                        completion(audios)
                    }
                }
            }
        }
    }

    /// Retrieve audio message from storage firebase
    ///
    /// - Parameters:
    ///   - uuid: uuid of user
    ///   - completion: handler for data or error
    func retrieveAudioMessage(uuid: UUID, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        let fileName: String = uuid.uuidString + ".caf"
        storageMechanism.retrieveAudio(directory: "messages", fileName: fileName) { (data, error) in
            if error != nil {
                print("LOG: \(error!.localizedDescription)")
            } else {
                completion(data, error)
            }
        }
    }

    /// Upload audio message on storage firebase
    ///
    /// - Parameters:
    ///   - url: url of the audio
    ///   - completion: id of the message, error handler
    func uploadAudioMessage(url: URL, completion: @escaping (_ id: UUID, _ error: Error?) -> Void) {
        let uuid = UUID()
        let fileName: String = uuid.uuidString + ".caf"

        storageMechanism.uploadAudio(directory: "messages", fileName: fileName, url: url) { (error) in
            if error != nil {
                print("LOG: \(error!.localizedDescription)")
            } else {
                completion(uuid, error)
            }
        }
    }

    /// Upload description id on database firebase
    ///
    /// - Parameters:
    ///   - userUid: user that recorded the audio
    ///   - values: array of key/value pairs: userUid (string), description (uuid string)
    ///   - completion: handler for error
    func uploadDescriptionId(userUid: String,
                             values: [String: String],
                             completion: @escaping (_ error: Error?) -> Void) {
        databaseMechanism.uploadDescriptionId(userUid: userUid, values: values) { (error) in
            if error != nil {
                completion(error!)
            } else {
                completion(nil)
            }
        }
    }

    /// Retrieve all descriptions ids
    ///
    /// - Parameter completion: dictionary containing the ids
    func retrieveDescriptions(completion: @escaping (_ value: NSDictionary?) -> Void) {
        databaseMechanism.retrieveDescriptions { (data) in
            completion(data)
        }
    }

    /// Retrieve description of an user
    ///
    /// - Parameters:
    ///   - userUid: user that recorded the audio
    ///   - completion: name of the description (uuid)
    func retrieveDescriptionId(userUid: String, completion: @escaping (_ uuid: String?) -> Void) {
        databaseMechanism.retrieveDescriptionId(userUid: userUid) { (uuid) in
            completion(uuid)
        }
    }
}
