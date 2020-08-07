//
//  AppDelegate.swift
//  AccessibilityChat
//
//  Created by Bianca Itiroko on 15/10/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let theme = UserDefaultsManager.getTheme()
    
    let tabBarController = UITabBarController()

    public var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        FirebaseApp.configure()
        setupIQKeyboard()
        theme.customizeNavigationBarAppearence()
        
        var navigationController: UINavigationController!
        
        if UserDefaultsManager.getNumberOfExecutions() == 0 {
            navigationController = UINavigationController(rootViewController: ChooseThemeViewController())
        } else {
            if UserDefaultsManager.getDidChoseTheme() {
                if UserServices().userUid() == nil {
                    navigationController = UINavigationController(rootViewController: LoginViewController())
                } else {
                    self.window?.rootViewController = self.initialTabBarController()
                    self.window?.makeKeyAndVisible()
                    return true
                }
            } else {
                navigationController = UINavigationController(rootViewController: ChooseThemeViewController())
            }
        }
        
        // increase number of executions
        UserDefaultsManager.updateNumberOfExecutions()
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }

    func setupIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func initialTabBarController() -> UITabBarController {
        tabBarController.tabBar.barStyle = theme.navigationBarStyle
        
        let exploreViewController = UIStoryboard(name: "Explore", bundle: nil)
            .instantiateViewController(withIdentifier: "ExploreViewController") as? ExploreViewController
        let exploreNavigationController = UINavigationController(
            rootViewController: exploreViewController ?? UIViewController()
        )
        
        let messagesViewController = MessagesController()
        let messagesNavigationController = UINavigationController(rootViewController: messagesViewController)
        
        let settingsViewController = UIStoryboard(name: "Settings", bundle: nil)
            .instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
        let settingsNavigationController = UINavigationController(
            rootViewController: settingsViewController ?? UIViewController()
        )
        
        let tabBarControllers = [exploreNavigationController,
                                 messagesNavigationController,
                                 settingsNavigationController]
        
        exploreNavigationController.tabBarItem.image = theme.unselectedExploreIcon
            .withRenderingMode(.alwaysOriginal)
        
        exploreNavigationController.tabBarItem.selectedImage = theme.selectedExploreIcon
            .withRenderingMode(.alwaysOriginal)
        
        exploreNavigationController.tabBarItem.title = ""
        exploreNavigationController.tabBarItem.accessibilityLabel = "Explore"
        
        messagesNavigationController.tabBarItem.image = theme.unselectedMessagesIcon
            .withRenderingMode(.alwaysOriginal)
        
        messagesNavigationController.tabBarItem.selectedImage = theme.selectedMessagesIcon
            .withRenderingMode(.alwaysOriginal)
        
        messagesNavigationController.tabBarItem.title = ""
        messagesNavigationController.tabBarItem.accessibilityLabel = "Conversas"
        
        settingsNavigationController.tabBarItem.image = theme.unselectedSettingsIcon
            .withRenderingMode(.alwaysOriginal)
        
        settingsNavigationController.tabBarItem.selectedImage = theme.selectedSettingsIcon
            .withRenderingMode(.alwaysOriginal)
        
        settingsNavigationController.tabBarItem.title = ""
        settingsNavigationController.tabBarItem.accessibilityLabel = "Configurações"
        
        tabBarController.setViewControllers(tabBarControllers, animated: false)
        tabBarController.selectedViewController = exploreNavigationController
        
        return tabBarController
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
//        Sent when the application is about to move from active to inactive state.
//        This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
//        or when the user quits the application and it begins the transition to the background state.
//        Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
//        Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        Use this method to release shared resources, save user data, invalidate timers,
//        and store enough application state information to restore your application
//        to its current state in case it is terminated later.
//        If your application supports background execution, this method is
//        called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//        Called as part of the transition from the background to the active state;
//        here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        Restart any tasks that were paused (or not yet started) while the application was inactive.
//        If the application was previously in the background,
//        optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
//        Called when the application is about to terminate. Save data if appropriate.
//        See also applicationDidEnterBackground:.
    }
}
