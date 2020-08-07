//
//  LightTheme.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/25/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import UIKit

class LightTheme: Theme {
    var themeType: ThemeType = ThemeType.light
    
    var loadingGIFName: String = "loading_gif_lightmode"

    var unselectedExploreIcon: UIImage = UIImage(named: "iconUnselectedIconExploreLight") ?? UIImage()
    var unselectedMessagesIcon: UIImage = UIImage(named: "iconUnselectedIconMessagesLight") ?? UIImage()
    var unselectedSettingsIcon: UIImage = UIImage(named: "iconUnselectedIconSettingsLight") ?? UIImage()
    
    var selectedExploreIcon: UIImage = UIImage(named: "iconSelectedIconExploreLight") ?? UIImage()
    var selectedMessagesIcon: UIImage = UIImage(named: "iconSelectedIconMessagesLight") ?? UIImage()
    var selectedSettingsIcon: UIImage = UIImage(named: "iconSelectedIconSettingsLight") ?? UIImage()
    
    var backgroundColor: UIColor = .white
    var gradientColors: [UIColor] = [.purpleishBlue, .middlePurple, .warmPurple]
    
    var navigationBarStyle: UIBarStyle = .default
    
    var statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.default
    var topbarBackgroundColor: UIColor = .white
    
    var configTitleColor: UIColor = .purpleishBlue
    var currentThemeTitleColor: UIColor = .warmPurple
    var changeThemeButtonTitleColor: UIColor = .white
    var changeThemeButtonColor: UIColor = .warmPurple
    
    var recordTitleColor: UIColor = .purpleishBlue
    var recordDescriptionColor: UIColor = .purpleishBlue
    var recordButtonTitleColor: UIColor = .white
    var recordCancelButtonColor: UIColor = .warmPurple
    var recordCancelButtonTitleColor: UIColor = .white
    var recordPauseButtonTitleColor: UIColor = .warmPurple
    
    var confirmRecordLabelsColor: UIColor = .warmPurple
    var confirmRecordButtonTitleColor: UIColor = .white
    var confirmRecordButtonColor: UIColor = .warmPurple
    var confirmRecordSeparatorColor: UIColor = .warmPurple
    var confirmRecordProgressBarColor: UIColor = .warmPurple

    var exploreLabelsColor: UIColor = .white
    var exploreButtonTitleColor: UIColor = .warmPurpleTwo
    var exploreButtonColor: UIColor = .white
    var previousButtonImage: UIImage = UIImage(named: "previousButton-Light") ?? UIImage()
    var nextButtonImage: UIImage = UIImage(named: "nextButton-Light") ?? UIImage()
    
    var formFieldLabelColor: UIColor = .white
    var formFieldPlaceholderColor: UIColor = .grey
    var arrowDownImage: UIImage = UIImage(named: "arrowDown-Light") ?? UIImage()
    var registerButtonColor: UIColor = .white
    var registerButtonTitleColor: UIColor = .warmPurple
    var errorBalloonImage: UIImage = UIImage(named: "errorBalloon-Light") ?? UIImage()
    var errorLabelColor: UIColor = .burple
    var errorButtonColor: UIColor  = .warmPurple
    
    var playButton: UIImage = UIImage(named: "playButton-Light") ?? UIImage()
    var pauseButton: UIImage = UIImage(named: "pauseButton-Light") ?? UIImage()
    var redoButton: UIImage = UIImage(named: "redoButton-Light") ?? UIImage()

    var playLeftButton: UIImage = UIImage(named: "light_play_left") ?? UIImage()
    var pauseLeftButton: UIImage = UIImage(named: "light_pause_left") ?? UIImage()
    var playRightButton: UIImage = UIImage(named: "light_play_right") ?? UIImage()
    var pauseRightButton: UIImage = UIImage(named: "light_pause_right") ?? UIImage()

    var leftBalloon: UIImage = UIImage(named: "leftBalloon-Light") ?? UIImage()
    var rightBalloon: UIImage = UIImage(named: "rightBalloon-Light") ?? UIImage()
    var leftBalloonFill: UIImage = UIImage(named: "leftBalloonFill-Light") ?? UIImage()
    var rightBalloonFill: UIImage = UIImage(named: "rightBalloonFill-Light") ?? UIImage()

    // Edit Profile
    var editProfileLabelsColor: UIColor = .white
    var primaryCellBackgroundColor: UIColor = .purpleishBlue
    var secondaryCellBackgroundColor: UIColor = .warmPurple
    var cellBorderColor: UIColor = .black
    var editProfileUpArrow: UIImage = UIImage(named: "editProfileUpArrow-Light") ?? UIImage()
    var editProfileDownArrow: UIImage = UIImage(named: "editProfileDownArrow-Light") ?? UIImage()
    var editProfileSeparatorColor: UIColor = .white
    
    // Chat History
    var chatHistoryPlayButton: UIImage = UIImage(named: "playButtonChat-Light")!
    var chatHistoryNameLabelColor: UIColor = .black
    var chatHistoryTimeLabelColor: UIColor = .black
    var chatHistoryNotificationLabelColor: UIColor = .white
    var chatHistoryNotificationBackgroundColor: UIColor = .purpleishBlue

//    var playButton: UIImage = UIImage(named: "playButton-Light")!
//    var pauseButton: UIImage = UIImage(named: "pauseButton-Light")!
//    var redoButton: UIImage = UIImage(named: "redoButton-Light")!

    var leftBalloonTextColor: UIColor = .black
    var rightBalloonTextColor: UIColor = .black

    var leftAudioBalloonTextColor: UIColor = .black
    var rightAudioBalloonTextColor: UIColor = .black

    var inputTextFieldBackgroundColor: UIColor = .purpleishBlue
    var inputTextFieldTintColor: UIColor = .white

    var sendImage: UIImage = UIImage(named: "light_send") ?? UIImage()
    var micImage: UIImage = UIImage(named: "light_mic") ?? UIImage()
    
    // Settings screen
    var textColor: UIColor = .black
    var textAlertColor: UIColor = .red
    var tableViewSeparatorColor: UIColor = .lightGray
    
    // Report
    var reportImage: UIImage = #imageLiteral(resourceName: "report-Light")
    
    var errorTextFieldColor: UIColor = .grey
}
