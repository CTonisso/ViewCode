//
//  ACViewController.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/13/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class ACViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme: Theme = UserDefaultsManager.getTheme()
        let tabBar = self.navigationController?.tabBarController?.tabBar
        self.navigationController?.navigationBar.barStyle = theme.navigationBarStyle
        tabBar?.barStyle = theme.navigationBarStyle
        
        let explore = tabBar?.items?[0]
        explore?.selectedImage = theme.selectedExploreIcon.withRenderingMode(.alwaysOriginal)
        explore?.image = theme.unselectedExploreIcon.withRenderingMode(.alwaysOriginal)
        
        let messages = tabBar?.items?[1]
        messages?.selectedImage = theme.selectedMessagesIcon.withRenderingMode(.alwaysOriginal)
        messages?.image = theme.unselectedMessagesIcon.withRenderingMode(.alwaysOriginal)
        
        let settings = tabBar?.items?[2]
        settings?.selectedImage = theme.selectedSettingsIcon.withRenderingMode(.alwaysOriginal)
        settings?.image = theme.unselectedSettingsIcon.withRenderingMode(.alwaysOriginal)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UserDefaultsManager.getTheme().statusBarStyle
    }

}
