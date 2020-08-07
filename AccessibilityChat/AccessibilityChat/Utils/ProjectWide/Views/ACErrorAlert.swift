//
//  ACErrorAlert.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/29/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import UIKit
import Cartography

class ACErrorAlert: UIView, Modal {
    
    let theme = UserDefaultsManager.getTheme()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.frame = self.frame
        view.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        return view
    }()
    
    lazy var dialogView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.errorButtonColor
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = theme.backgroundColor
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Stilu-Bold", size: 20)
        label.textAlignment = .center
        label.backgroundColor = theme.backgroundColor
        label.textColor = theme.errorLabelColor
        return label
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(theme.errorButtonColor, for: .normal)
        button.backgroundColor = theme.backgroundColor
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Stilu-Bold", size: 20)
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(theme.errorButtonColor, for: .normal)
        button.backgroundColor = theme.backgroundColor
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        button.setTitle("Fechar", for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-Bold", size: 20)
        return button
    }()
    
    convenience init(message: String, button: ErrorNavigationButton) {
        self.init(frame: UIScreen.main.bounds)
        setupInitialState()
        errorMessageLabel.text = message
        actionButton.setTitle(button.title, for: .normal)
        actionButton.addTarget(self, action: button.action, for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInitialState() {
        self.addSubview(backgroundView)
        self.addSubview(dialogView)
        self.dialogView.addSubview(stackView)
        self.stackView.addArrangedSubview(errorMessageLabel)
        self.stackView.addArrangedSubview(actionButton)
        self.stackView.addArrangedSubview(closeButton)
        setupDialogView()
        setupStackView()
        setupLabel()
        setupButtons()
    }
    
    func setupDialogView() {
        constrain(dialogView) { view in
            guard let superview = view.superview else { return }
            view.top == superview.top + 220
            view.left == superview.left + 52
            view.right == superview.right - 52
            view.centerX == superview.centerX
        }
    }
    
    func setupStackView() {
        constrain(stackView) { view in
            guard let superview = view.superview else { return }
            view.edges == inset(superview.edges, 5, 5, 5, 5)
        }
    }
    
    func setupLabel() {
        constrain(errorMessageLabel) { label in
            guard let superview = label.superview else { return }
            label.width == superview.width
            label.height == 100
            label.centerX == superview.centerX
        }
    }
    
    func setupButtons() {
        constrain(actionButton, closeButton) { action, close in
            guard let superview = action.superview else { return }
            action.width == superview.width
            action.height == 60
            action.centerX == superview.centerX
            close.width == superview.width
            close.height == 60
            close.centerX == superview.centerX
        }
    }
    
    @objc func dismissAlert() {
        self.dismiss(animated: true)
    }
}
