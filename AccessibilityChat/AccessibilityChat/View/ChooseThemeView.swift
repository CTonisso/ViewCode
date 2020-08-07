//
//  ChooseThemeView.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 11/22/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import Cartography

extension ChooseThemeViewController {
    func defineConfigThemeLabel() -> UILabel {
        let label = UILabel()
        label.text = "Selecionar tema"
        label.font = UIFont(name: "Stilu-Bold", size: 35)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = theme.configTitleColor
        
        label.isAccessibilityElement = true
        label.accessibilityTraits = UIAccessibilityTraits.staticText
        
        return label
    }
    
    func defineCurrentThemeLabel() -> UILabel {
        let label = UILabel()
        label.text = theme.themeType == ThemeType.light ? "Você está no Light Mode" : "Você está no Dark Mode"
        label.font = UIFont(name: "Stilu-Bold", size: 25)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = theme.currentThemeTitleColor
        
        label.isAccessibilityElement = true
        label.accessibilityTraits = UIAccessibilityTraits.staticText
        
        return label
    }
    
    func defineChangeThemeButton() -> UIButton {
        let button = UIButton()
        let title = theme.themeType == ThemeType.light ? "Ativar Dark Mode" : "Ativar Light Mode"
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-Bold", size: 25)
        button.setTitleColor(theme.currentThemeTitleColor, for: .normal)
        button.backgroundColor = theme.changeThemeButtonColor
        button.titleLabel?.numberOfLines = 0
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        button.isAccessibilityElement = true
        button.accessibilityTraits = UIAccessibilityTraits.button
        
        return button
    }
    
    func defineContinueButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Continuar", for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-Bold", size: 25)
        button.setTitleColor(theme.currentThemeTitleColor, for: .normal)
        button.backgroundColor = theme.changeThemeButtonColor
        button.titleLabel?.numberOfLines = 0
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        button.isAccessibilityElement = true
        button.accessibilityTraits = UIAccessibilityTraits.button
        
        return button
    }
    
    func setupInitialState() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(stackView)
        
        self.configThemeLabel = defineConfigThemeLabel()
        self.currentThemeLabel = defineCurrentThemeLabel()
        self.changeThemeButton = defineChangeThemeButton()
        self.continueButton = defineContinueButton()
        
        setupScrollView()
        setupStackView()
        setupButton()
        setupLabels()
    }
    
    func setupScrollView() {
        constrain(scrollView) { view in
            guard let superview = view.superview else { return }
            view.edges == superview.edges
        }
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(configThemeLabel)
        stackView.addArrangedSubview(currentThemeLabel)
        stackView.addArrangedSubview(changeThemeButton)
        stackView.setCustomSpacing(100.0, after: changeThemeButton)
        stackView.addArrangedSubview(continueButton)
        constrain(stackView) { view in
            guard let superview = view.superview else { return }
            view.top == superview.top + 15
            view.width == superview.width * 0.8
            view.centerX == superview.centerX
            view.bottom == superview.bottom - 16
        }
    }
    
    func setupLabels() {
        constrain(configThemeLabel, currentThemeLabel) { configLabel, currentLabel in
            guard let superview = configLabel.superview else { return }
            configLabel.width == superview.width
            currentLabel.width == superview.width
        }
    }
    
    func setupButton() {
        changeThemeButton.addTarget(self, action: #selector(changeThemePressed(_:)), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continuePressed(_:)), for: .touchUpInside)
        
        constrain(changeThemeButton, continueButton) { changeThemeButton, continueButton in
            guard let superview = changeThemeButton.superview else { return }
            changeThemeButton.width == superview.width
            changeThemeButton.height >= 120
            continueButton.width == superview.width
            continueButton.height >= 50
        }
    }
    
    func setTheme(theme: Theme) {
        self.view.backgroundColor = theme.backgroundColor
        self.configThemeLabel.textColor = theme.configTitleColor
        self.currentThemeLabel.textColor = theme.currentThemeTitleColor
        self.changeThemeButton.setTitleColor(theme.changeThemeButtonTitleColor, for: .normal)
        self.changeThemeButton.backgroundColor = theme.changeThemeButtonColor
        self.continueButton.setTitleColor(theme.changeThemeButtonTitleColor, for: .normal)
        self.continueButton.backgroundColor = theme.changeThemeButtonColor
        self.navigationController?.navigationBar.barStyle = theme.navigationBarStyle
    }
    
    func setupLabelsForAccessibility() {
        self.configThemeLabel.setupAdjustableFont()
        self.currentThemeLabel.setupAdjustableFont()
        self.changeThemeButton.titleLabel?.setupAdjustableFont()
        self.continueButton.titleLabel?.setupAdjustableFont()
    }
}
