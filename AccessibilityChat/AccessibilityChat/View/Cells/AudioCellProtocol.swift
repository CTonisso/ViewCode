//
//  AudioCellModel.swift
//  AccessibilityChat
//
//  Created by Bianca Itiroko on 06/11/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import UIKit

protocol AudioCellProtocol: ProgressBarDelegate, PlayPauseButtonDelegate {
    var progressView: UIProgressView { get }
    var playPauseButton: PlayPauseButton { get }
    var activityIndicator: UIActivityIndicatorView { get }
    var audioData: Data? { get set }
    var timeLabel: UILabel { get set }
    var url: URL? { get set }
    var delegate: AudioCellDelegate? { get set }
    var progressViewCurrentTime: Double { get set }
}
