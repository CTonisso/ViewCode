//
//  ThemeProtocol.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/25/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import UIKit

enum ThemeType: String {
    case light
    case dark
}

protocol Theme: class {
    var themeType: ThemeType { get }
    
    func customizeNavigationBarAppearence()
    
    // loading gif
    var loadingGIFName: String { get }
    
    //Tab Bar icons
    var unselectedExploreIcon: UIImage { get }
    var unselectedMessagesIcon: UIImage { get }
    var unselectedSettingsIcon: UIImage { get }
    
    var selectedExploreIcon: UIImage { get }
    var selectedMessagesIcon: UIImage { get }
    var selectedSettingsIcon: UIImage { get }
    
    var backgroundColor: UIColor { get }
    var gradientColors: [UIColor] { get }
    
    var navigationBarStyle: UIBarStyle { get }
    
    var statusBarStyle: UIStatusBarStyle { get }
    var topbarBackgroundColor: UIColor { get }
    
    // ChooseTheme Screen
    var configTitleColor: UIColor { get }
    var currentThemeTitleColor: UIColor { get }
    var changeThemeButtonTitleColor: UIColor { get }
    var changeThemeButtonColor: UIColor { get }
    
    // RecordAudio Screen
    var recordTitleColor: UIColor { get }
    var recordDescriptionColor: UIColor { get }
    var recordButtonTitleColor: UIColor { get }
    var recordCancelButtonColor: UIColor { get }
    var recordCancelButtonTitleColor: UIColor { get }
    var recordPauseButtonTitleColor: UIColor { get }
    
    // ConfirmRecord Screen
    var confirmRecordLabelsColor: UIColor { get }
    var confirmRecordButtonTitleColor: UIColor { get }
    var confirmRecordButtonColor: UIColor { get }
    var confirmRecordSeparatorColor: UIColor { get }
    var confirmRecordProgressBarColor: UIColor { get }
    
    // Explore Screen Cell
    var exploreLabelsColor: UIColor { get }
    var exploreButtonTitleColor: UIColor { get }
    var exploreButtonColor: UIColor { get }
    var previousButtonImage: UIImage { get }
    var nextButtonImage: UIImage { get }
    
    // Register Screen
    var formFieldLabelColor: UIColor { get }
    var formFieldPlaceholderColor: UIColor { get }
    var arrowDownImage: UIImage { get }
    var registerButtonColor: UIColor { get }
    var registerButtonTitleColor: UIColor { get }
    var errorBalloonImage: UIImage { get }
    var errorLabelColor: UIColor { get }
    var errorButtonColor: UIColor { get }
    
    // Edit Profile
    var editProfileLabelsColor: UIColor { get }
    var primaryCellBackgroundColor: UIColor { get }
    var secondaryCellBackgroundColor: UIColor { get }
    var cellBorderColor: UIColor { get }
    var editProfileUpArrow: UIImage { get }
    var editProfileDownArrow: UIImage { get }
    var editProfileSeparatorColor: UIColor { get }
    
    // Chat History
    var chatHistoryPlayButton: UIImage { get }
    var chatHistoryNameLabelColor: UIColor { get }
    var chatHistoryTimeLabelColor: UIColor { get }
    var chatHistoryNotificationLabelColor: UIColor { get }
    var chatHistoryNotificationBackgroundColor: UIColor { get }
    
    var playButton: UIImage { get }
    var pauseButton: UIImage { get }
    var redoButton: UIImage { get }

    var playLeftButton: UIImage { get }
    var pauseLeftButton: UIImage { get }
    var playRightButton: UIImage { get }
    var pauseRightButton: UIImage { get }

    var leftBalloon: UIImage { get }
    var rightBalloon: UIImage { get }
    var leftBalloonFill: UIImage { get }
    var rightBalloonFill: UIImage { get }

    var leftBalloonTextColor: UIColor { get }
    var rightBalloonTextColor: UIColor { get }

    var leftAudioBalloonTextColor: UIColor { get }
    var rightAudioBalloonTextColor: UIColor { get }

    var inputTextFieldBackgroundColor: UIColor { get }
    var inputTextFieldTintColor: UIColor { get }

    var micImage: UIImage { get }
    var sendImage: UIImage { get }
    
    // Settings Screen
    var textColor: UIColor { get }
    var textAlertColor: UIColor { get }
    var tableViewSeparatorColor: UIColor { get }
    
    // Report
    var reportImage: UIImage { get }
    
    var errorTextFieldColor: UIColor { get }
}

extension Theme {
    func customizeNavigationBarAppearence() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barStyle = self.navigationBarStyle
//        navigationBarAppearance.isOpaque = true
        
        let tabBar = appDelegate.tabBarController.tabBar
        tabBar.barStyle = self.navigationBarStyle
//        tabBar.isOpaque = true
    }
}
