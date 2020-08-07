//
//  DarkTheme.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/25/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import UIKit

class DarkTheme: Theme {
    var themeType: ThemeType = ThemeType.dark
    
    var loadingGIFName: String = "loading_gif_darkmode"
    
    var unselectedExploreIcon: UIImage = UIImage(named: "iconUnselectedExploreDark") ?? UIImage()
    var unselectedMessagesIcon: UIImage = UIImage(named: "iconUnselectedMessagesDark") ?? UIImage()
    var unselectedSettingsIcon: UIImage = UIImage(named: "iconUnselectedSettingsDark") ?? UIImage()
    
    var selectedExploreIcon: UIImage = UIImage(named: "iconSelectedExploreDark") ?? UIImage()
    var selectedMessagesIcon: UIImage = UIImage(named: "iconSelectedMessagesDark") ?? UIImage()
    var selectedSettingsIcon: UIImage = UIImage(named: "iconSelectedSettingsDark") ?? UIImage()
    
    var backgroundColor: UIColor = .black
    var gradientColors: [UIColor] = [.babyGreen, .greyblue, .bluePurple]
    
    var navigationBarStyle: UIBarStyle = .blackOpaque
    
    var statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.lightContent
    var topbarBackgroundColor: UIColor = .black
    
    var configTitleColor: UIColor = .babyGreen
    var currentThemeTitleColor: UIColor = .babyGreen
    var changeThemeButtonTitleColor: UIColor = .babyGreen
    var changeThemeButtonColor: UIColor = .bluePurple
    
    var recordTitleColor: UIColor = .babyGreen
    var recordDescriptionColor: UIColor = .babyGreen
    var recordButtonTitleColor: UIColor = .white
    var recordCancelButtonColor: UIColor = .bluePurpleTwo
    var recordCancelButtonTitleColor: UIColor = .babyGreen
    var recordPauseButtonTitleColor: UIColor = .babyGreen
    
    var confirmRecordLabelsColor: UIColor = .babyGreen
    var confirmRecordButtonTitleColor: UIColor = .babyGreen
    var confirmRecordButtonColor: UIColor = .bluePurpleTwo
    var confirmRecordSeparatorColor: UIColor = .babyGreen
    var confirmRecordProgressBarColor: UIColor = .black
    
    var exploreLabelsColor: UIColor = .babyGreen
    var exploreButtonTitleColor: UIColor = .babyGreen
    var exploreButtonColor: UIColor = .bluePurpleTwo
    var previousButtonImage: UIImage = UIImage(named: "previousButton-Dark") ?? UIImage()
    var nextButtonImage: UIImage = UIImage(named: "nextButton-Dark") ?? UIImage()

    var formFieldLabelColor: UIColor = .babyGreen
    var formFieldPlaceholderColor: UIColor = .blackTwo
    var arrowDownImage: UIImage = UIImage(named: "arrowDown-Dark") ?? UIImage()
    var registerButtonColor: UIColor = .bluePurpleTwo
    var registerButtonTitleColor: UIColor = .babyGreen
    var errorBalloonImage: UIImage = UIImage(named: "errorBalloon-Dark") ?? UIImage()
    var errorLabelColor: UIColor = .white
    var errorButtonColor: UIColor  = .babyGreen
    
    // Edit Profile
    var editProfileLabelsColor: UIColor = .white
    var primaryCellBackgroundColor: UIColor = .black
    var secondaryCellBackgroundColor: UIColor = .black
    var cellBorderColor: UIColor = .babyGreen
    var editProfileUpArrow: UIImage = UIImage(named: "editProfileUpArrow-Dark") ?? UIImage()
    var editProfileDownArrow: UIImage = UIImage(named: "editProfileDownArrow-Dark") ?? UIImage()
    var editProfileSeparatorColor: UIColor = .babyGreen
    
    // Chat History
    var chatHistoryPlayButton: UIImage = UIImage(named: "playButtonChat-Dark") ?? UIImage()
    var chatHistoryNameLabelColor: UIColor = .babyGreen
    var chatHistoryTimeLabelColor: UIColor = .white
    var chatHistoryNotificationLabelColor: UIColor = .white
    var chatHistoryNotificationBackgroundColor: UIColor = .bluePurpleTwo
    
    var playButton: UIImage = UIImage(named: "playButton-Dark")!
    var pauseButton: UIImage = UIImage(named: "pauseButton-Dark")!
    var redoButton: UIImage = UIImage(named: "redoButton-Dark")!

    var playLeftButton: UIImage = UIImage(named: "dark_play_left") ?? UIImage()
    var pauseLeftButton: UIImage = UIImage(named: "dark_pause_left") ?? UIImage()
    var playRightButton: UIImage = UIImage(named: "dark_play_right") ?? UIImage()
    var pauseRightButton: UIImage = UIImage(named: "dark_pause_right") ?? UIImage()

    var leftBalloon: UIImage = UIImage(named: "leftBalloon-Dark") ?? UIImage()
    var rightBalloon: UIImage = UIImage(named: "rightBalloon-Dark") ?? UIImage()
    var leftBalloonFill: UIImage = UIImage(named: "leftBalloonFill-Dark") ?? UIImage()
    var rightBalloonFill: UIImage = UIImage(named: "rightBalloonFill-Dark") ?? UIImage()

    var leftBalloonTextColor: UIColor = .white
    var rightBalloonTextColor: UIColor = .babyGreen

    var leftAudioBalloonTextColor: UIColor = .bluePurpleTwo
    var rightAudioBalloonTextColor: UIColor = .black

    var inputTextFieldBackgroundColor: UIColor = .babyGreen
    var inputTextFieldTintColor: UIColor = .black

    var sendImage: UIImage = UIImage(named: "dark_send") ?? UIImage()
    var micImage: UIImage = UIImage(named: "dark_mic") ?? UIImage()
    
    // Settings screen
    var textColor: UIColor = .babyGreen
    var textAlertColor: UIColor = .red
    var tableViewSeparatorColor: UIColor = .babyGreen
    
    // Report
    var reportImage: UIImage = #imageLiteral(resourceName: "report-Dark")
    
    var errorTextFieldColor: UIColor = .black
}
