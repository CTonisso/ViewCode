//
//  FormFieldView.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/3/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Cartography
import SwiftMaskTextfield

class FormFieldView: UIView {
    let theme: Theme = UserDefaultsManager.getTheme()
    let placeholderAttributes: [NSAttributedString.Key: Any]
    
    enum Config {
        case email(title: String, placeholder: String)
        case password(title: String, placeholder: String)
        case birthDate(title: String, placeholder: String)
        case state(title: String, placeholder: String)
        case city(title: String, placeholder: String)
        case name(title: String, placeholder: String)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Stilu-bold", size: 20)
        label.textColor = theme.formFieldLabelColor
        return label
    }()
    
    lazy var leftTextFieldView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        return view
    }()
    
    lazy var formTextField: AccessibilityChatTextField = {
        let textField = AccessibilityChatTextField()
        textField.clipsToBounds = true
        textField.font = UIFont(name: "System-semibold", size: 18)
        textField.tintColor = theme.formFieldPlaceholderColor
        textField.backgroundColor = .white
        textField.leftViewMode = .always
        return textField
    }()
    
    lazy var indicatorView: UIImageView = {
        let image = UIImageView()
        image.image = theme.arrowDownImage
        return image
    }()
    
    override init(frame: CGRect) {
        placeholderAttributes = [NSAttributedString.Key.foregroundColor: self.theme.formFieldPlaceholderColor]
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        placeholderAttributes = [NSAttributedString.Key.foregroundColor: self.theme.formFieldPlaceholderColor]
        super.init(coder: aDecoder)
        configureAppearance()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        formTextField.layer.cornerRadius = formTextField.frame.height / 2
    }

    func configureAppearance() {
        self.addSubview(titleLabel)
        self.addSubview(formTextField)
        self.backgroundColor = .clear
        constrain(titleLabel, formTextField) { title, textField in
            guard let superview = title.superview else { return }
            title.top == superview.top
            title.left == superview.left
            textField.height == 40
            textField.top == title.bottom + 4
            textField.left == title.left
            textField.right == superview.right
            textField.bottom == superview.bottom
        }
        formTextField.leftView = self.leftTextFieldView
    }
    
    func configure(for config: Config) {
        switch config {
        case .birthDate(let title, let placeholder):
            configureBirthDate(title: title, placeholder: placeholder)
        case .city(let title, let placeholder):
            configureCity(title: title, placeholder: placeholder)
        case .email(let title, let placeholder):
            configureEmail(title: title, placeholder: placeholder)
        case .password(let title, let placeholder):
            configurePassword(title: title, placeholder: placeholder)
        case .state(let title, let placeholder):
            configureState(title: title, placeholder: placeholder)
        case .name(let title, let placeholder):
            configureName(title: title, placeholder: placeholder)
        }
    }
    
    func configureName(title: String, placeholder: String) {
        titleLabel.text = title
        formTextField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: placeholderAttributes)
        formTextField.accessibilityHint = placeholder
        formTextField.autocapitalizationType = .words
        formTextField.keyboardType = .default
        formTextField.autocorrectionType = .no
        formTextField.textContentType = UITextContentType.name
    }
    
    func configureBirthDate(title: String, placeholder: String) {
        titleLabel.text = title
        formTextField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: placeholderAttributes)
        formTextField.accessibilityHint = placeholder
        formTextField.keyboardType = .numberPad
        formTextField.formatPattern = "##/##/####"
    }
    
    func configureCity(title: String, placeholder: String) {
        titleLabel.text = title
        formTextField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: placeholderAttributes)
        formTextField.accessibilityHint = placeholder
        addIndicatorView()
    }
    
    func configureEmail(title: String, placeholder: String) {
        titleLabel.text = title
        formTextField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: placeholderAttributes)
        formTextField.accessibilityHint = placeholder
        formTextField.autocapitalizationType = .none
        formTextField.keyboardType = .emailAddress
        formTextField.textContentType = .emailAddress
        formTextField.autocorrectionType = .no
        formTextField.textContentType = UITextContentType.emailAddress
    }
    
    func configurePassword(title: String, placeholder: String) {
        titleLabel.text = title
        formTextField.isSecureTextEntry = true
        formTextField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: placeholderAttributes)
        formTextField.accessibilityHint = placeholder
    }
    
    func configureState(title: String, placeholder: String) {
        titleLabel.text = title
        formTextField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                  attributes: placeholderAttributes)
        formTextField.accessibilityHint = placeholder
        addIndicatorView()
    }
    
    func addIndicatorView() {
        self.addSubview(indicatorView)
        constrain(indicatorView, formTextField) { indicator, textField in
            guard let superview = indicator.superview else { return }
            indicator.right == superview.right - 21
            indicator.centerY == textField.centerY
        }
    }
}
