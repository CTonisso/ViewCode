//
//  ACErrorView.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/28/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Cartography

struct ErrorNavigationButton {
    var title: String
    var action: Selector
}

enum ConfigForm {
    case emptyName
    case wrongEmail
    case existingEmail(_ buttons: [ErrorNavigationButton])
    case weakPassword
    case unmatchingPassword
    case invalidBirth
    case city
    case state
    case success

    var description: String {
        switch self {
        case .city:
            return "A cidade inserida não é válida"
        case .emptyName:
            return "O nome inserido não é válido"
        case .wrongEmail:
            return "O email inserido não é válido"
        case .existingEmail:
            return "O email já está sendo utilizado"
        case .weakPassword:
            return "A senha é fraca, por favor insira outra"
        case .unmatchingPassword:
            return "A confirmação da senha não bate com a original"
        case .invalidBirth:
            return "A data de nascimento é inválida, use o formato dd/mm/aaaa"
        case .state:
            return "O estado inserido não é válido"
        default:
            return "Houve um erro, confirme os campos"
        }
    }
}

class ACErrorView: UIImageView {
    
    let theme = UserDefaultsManager.getTheme()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2
        stack.backgroundColor = .red
        return stack
    }()
    
    lazy var errorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = theme.errorLabelColor
        label.font = UIFont(name: "Stilu-bold", size: 16)
        label.backgroundColor = theme.backgroundColor
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitialState()
    }
    
    func setupInitialState() {
        self.image = theme.errorBalloonImage
        self.addSubview(stackView)
        stackView.addArrangedSubview(errorDescriptionLabel)
        setupStackView()
        setupErrorLabel()
    }
    
    func setupStackView() {
        constrain(stackView) { stack in
            guard let superview = stack.superview else { return }
            stack.edges == inset(superview.edges, 40, 10, 10, 10)
        }
    }
    
    func setupErrorLabel() {
        constrain(errorDescriptionLabel) { label in
            guard let superview = label.superview else { return }
            label.left == superview.left
            label.right == superview.right
            label.top == superview.top
            label.bottom == superview.bottom
        }
    }
    
    func configureFor(_ config: ConfigForm) {
        switch config {
        case .emptyName:
            configureEmptyName()
        case .wrongEmail:
            configureWrongEmail()
        case .existingEmail(let buttons):
            configureExistingEmail(buttons: buttons)
        case .weakPassword:
            configureWeakPassword()
        case .unmatchingPassword:
            configureUnmatchigPassword()
        case .invalidBirth:
            configureInvalidBirth()
        case .city:
            configureCity()
        case .state:
            configureState()
        case .success:
            break
        }
    }
    
    func configureEmptyName() {
        errorDescriptionLabel.text = "Digite seu nome."
    }
    
    func configureWrongEmail() {
        errorDescriptionLabel.text = "Digite um email no seguinte formato: seunome@exemplo.com."
    }

    func configureExistingEmail(buttons: [ErrorNavigationButton]) {
        errorDescriptionLabel.text = "Email já cadastrado."
        buttons.forEach { (button) in
            let newButton = UIButton()
            newButton.setTitle(button.title, for: .normal)
            newButton.addTarget(self, action: button.action, for: .touchUpInside)
            newButton.titleLabel?.font = UIFont(name: "Stilu-Bold", size: 16)
            newButton.setTitleColor(theme.errorButtonColor, for: .normal)
            newButton.backgroundColor = .white
            
            stackView.addArrangedSubview(newButton)
            
            constrain(newButton) { button in
                guard let superview = button.superview else { return }
                button.width == superview.width
                button.centerX == superview.centerX
                button.height >= 40
            }
        }
    }
    
    func configureWeakPassword() {
        errorDescriptionLabel.text = "A senha deve conter ao menos um número," +
        "uma letra maiúscula e uma letra minúsucula."
    }
    
    func configureUnmatchigPassword() {
        errorDescriptionLabel.text = "Digite a senha igual ao campo anterior."
    }
    
    func configureInvalidBirth() {
        errorDescriptionLabel.text = "Digite a data no seguinte formato: dd/mm/yyyy."
    }
    
    func configureCity() {
        errorDescriptionLabel.text = "Selecione uma cidade."
    }
    
    func configureState() {
        errorDescriptionLabel.text = "Selecione um estado."
    }
    
}
