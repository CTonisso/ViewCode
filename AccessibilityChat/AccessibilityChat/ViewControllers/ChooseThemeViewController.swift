//
//  ChooseThemeViewController.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/25/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class ChooseThemeViewController: ACViewController {
    let chooseThemePresenter: ChooseThemePresenter = ChooseThemePresenter()
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let theme: Theme = UserDefaultsManager.getTheme()
    
    let scrollView: UIScrollView = UIScrollView()
    let stackView: UIStackView = UIStackView()
    var configThemeLabel: UILabel!
    var currentThemeLabel: UILabel!
    var changeThemeButton: UIButton!
    var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        
        setupInitialState()
        setupLabelsForAccessibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTheme(theme: UserDefaultsManager.getTheme())
    }
    
    @objc func changeThemePressed(_ sender: UIButton) {
        if UserDefaultsManager.getThemeType() == ThemeType.light {
            UserDefaultsManager.setTheme(to: ThemeType.dark)
            
            UIView.animate(withDuration: 0.25) {
                self.changeThemeButton.setTitle("Ativar Light Mode", for: .normal)
                self.currentThemeLabel.text = "Você está no Dark Mode"
                self.setTheme(theme: DarkTheme())
            }
        } else {
            UserDefaultsManager.setTheme(to: ThemeType.light)
            
            UIView.animate(withDuration: 0.25) {
                self.changeThemeButton.setTitle("Ativar Dark Mode", for: .normal)
                self.currentThemeLabel.text = "Você está no Light Mode"
                self.setTheme(theme: LightTheme())
            }
        }
        
        theme.customizeNavigationBarAppearence()
    }
    
    @objc func continuePressed(_ sender: UIButton) {
        UserDefaultsManager.setDidChoseTheme(flag: true)
        
        guard let appDelegate = appDelegate else { return }
        
        var viewController: UIViewController
        
        if UserServices().userUid() == nil {
            viewController = LoginViewController()
        } else {
            viewController = appDelegate.initialTabBarController()
        }
        
        NavigationHelper.shared.switchRootViewController(to: viewController, withAnimation: .revealFromTop)
    }
}
