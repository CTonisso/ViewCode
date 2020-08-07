//
//  RegisterViewController.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/3/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Cartography
import Firebase

class RegisterViewController: ACViewController {
    let theme: Theme = UserDefaultsManager.getTheme()
    
    let presenter = RegisterPresenter()

    lazy var background: UIScrollView = {
        let background = UIScrollView()
        return background
    }()
    
    lazy var statusBarBackground: UIView = {
        let view = UIView()
        view.backgroundColor = theme.backgroundColor
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 26
        return stack
    }()
    
    lazy var screenTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cadastro"
        label.font = UIFont(name: "Stilu-bold", size: 24)
        label.textAlignment = .center
        label.textColor = theme.formFieldLabelColor
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Já tem conta?"
        label.font = UIFont(name: "Stilu-bold", size: 18)
        label.textAlignment = .center
        label.textColor = theme.formFieldLabelColor
        return label
    }()
    
    lazy var clickHereButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clique aqui para entrar", for: .normal)
        button.setTitleColor(theme.formFieldLabelColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-bold", size: 18)
        button.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = theme.formFieldLabelColor
        return view
    }()
    
    lazy var nameFormView: FormFieldView = {
        let form = FormFieldView()
        form.configure(for: .name(title: "Nome", placeholder: "Digite seu nome"))
        return form
    }()
    
    lazy var emailFormView: FormFieldView = {
        let form = FormFieldView()
        form.configure(for: .email(title: "Email", placeholder: "Digite seu email"))
        return form
    }()
    
    lazy var passwordFormView: FormFieldView = {
        let form = FormFieldView()
        form.configure(for: .password(title: "Senha", placeholder: "Digite sua senha"))
        return form
    }()
    
    lazy var confirmPasswordFormView: FormFieldView = {
        let form = FormFieldView()
        form.configure(for: .password(title: "Confirmar senha", placeholder: "Repita sua senha"))
        return form
    }()
    
    lazy var birthDateFormView: FormFieldView = {
        let form = FormFieldView()
        form.configure(for: .birthDate(title: "Data de Nascimento",
                                       placeholder: "Digite sua data de nascimento"))
        return form
    }()
    
    lazy var stateFormView: FormFieldView = {
        let form = FormFieldView()
        form.configure(for: .state(title: "Estado",
                                   placeholder: "Digite seu estado"))
        return form
    }()
    
    lazy var cityFormView: FormFieldView = {
        let form = FormFieldView()
        form.configure(for: .city(title: "Cidade",
                                  placeholder: "Digite sua cidade"))
        return form
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.backgroundColor = theme.registerButtonColor
        button.setTitleColor(.gray, for: .disabled)
        button.setTitleColor(theme.registerButtonTitleColor, for: .normal)
        button.setTitle("Cadastrar", for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-bold", size: 24)
        button.isAccessibilityElement = true
        button.accessibilityHint = "Você deve aceitar os termos de uso para o cadastro!"
        button.isEnabled = false
        return button
    }()
    
    lazy var termsOfUseButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.backgroundColor = theme.registerButtonColor
        button.setTitleColor(theme.registerButtonTitleColor, for: .normal)
        button.setTitle("Ver termos de uso", for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-bold", size: 24)
        return button
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    lazy var checkButton: CheckButton = {
        let button = CheckButton()
        button.setImage(#imageLiteral(resourceName: "tableViewSeparator-Light"), for: .normal)
        button.addTarget(self, action: #selector(checkPressed), for: .touchUpInside)
        button.backgroundColor = .clear
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Aceitar os termos de uso"
        button.accessibilityHint = "Duplo toque para selecionar"
        button.accessibilityTraits = UIAccessibilityTraits.button
        return button
    }()
    
    lazy var acceptTermsLabel: UILabel = {
        let label = UILabel()
        label.text = "Aceito os termos de uso"
        label.font = UIFont(name: "Stilu-bold", size: 22)
        label.textAlignment = .center
        label.textColor = theme.formFieldLabelColor
        label.backgroundColor = .clear
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        setupBackgroundAppearence()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBackgroundAppearence()
    }
    
    func setupInitialState() {
        addSubViews()
        setupStatusBarBackground()
        setupStackView()
        setupTitleLabel()
        setupSubtitle()
        setupButtons()
        setupBackgroundAppearence()
    }
    
    func addSubViews() {
        self.view.addSubview(background)
        self.view.addSubview(statusBarBackground)
        constrain(background) { background in
            background.top == background.superview!.top
            background.bottom == background.superview!.bottom
            background.left == background.superview!.left
            background.right == background.superview!.right
        }
        background.addSubview(stackView)
        stackView.addArrangedSubview(screenTitleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(clickHereButton)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(nameFormView)
        stackView.addArrangedSubview(emailFormView)
        stackView.addArrangedSubview(passwordFormView)
        stackView.addArrangedSubview(confirmPasswordFormView)
        stackView.addArrangedSubview(birthDateFormView)
        stackView.addArrangedSubview(stateFormView)
        stackView.addArrangedSubview(cityFormView)
        stackView.addArrangedSubview(termsOfUseButton)
        horizontalStackView.addArrangedSubview(checkButton)
        horizontalStackView.addArrangedSubview(acceptTermsLabel)
        stackView.addArrangedSubview(horizontalStackView)
        stackView.addArrangedSubview(registerButton)
    }
    
    func setupStatusBarBackground() {
        constrain(statusBarBackground) { view in
            guard let superview = view.superview else { return }
            view.height == UIApplication.shared.statusBarFrame.height
            view.width == superview.width
            view.left == superview.left
            view.right == superview.right
            view.top == superview.top
        }
    }
    
    func setupStackView() {
        stackView.setCustomSpacing(-2, after: subtitleLabel)
        stackView.setCustomSpacing(0, after: clickHereButton)
        stackView.setCustomSpacing(40, after: cityFormView)
        
        constrain(stackView) { stack in
            guard let superview = stack.superview else { return }
            stack.width == superview.width * 0.9
            stack.top == superview.top + 32
            stack.centerX == superview.centerX
            stack.bottom == superview.bottom - 32
        }
        
        stackView.arrangedSubviews.forEach { (view) in
            if view is FormFieldView {
                constrain(view) { view in
                    view.width == view.superview!.width
                    view.centerX == view.superview!.centerX
                }
            } else {
                constrain(view) { view in
                    view.centerX == view.superview!.centerX
                }
            }
        }
    }

    func setupTitleLabel() {
        constrain(screenTitleLabel) { label in
            guard let superview = label.superview else { return }
            label.centerX == superview.centerX
        }
    }
    
    func setupSubtitle() {
        constrain(screenTitleLabel, subtitleLabel,
                  clickHereButton, separatorView) { title, subtitle, button, separator in
                    subtitle.centerX == title.centerX
                    
                    button.centerX == subtitle.centerX
                    
                    separator.height == 2
                    separator.width == button.width
                    separator.centerX == button.centerX
        }
        separatorView.layer.cornerRadius = 1
    }
    
    func setupButtons() {
        constrain(registerButton) { button in
            button.height == 52
            button.width == 300
        }
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        registerButton.layer.cornerRadius = 10
        
        constrain(termsOfUseButton) { button in
            button.height == 52
            button.width == 300
        }
        termsOfUseButton.addTarget(self, action: #selector(showTerms), for: .touchUpInside)
        termsOfUseButton.layer.cornerRadius = 10
        
        constrain(checkButton) { button in
            button.height == 30
            button.width == 30
        }
    }
    
    func setupBackgroundAppearence() {
        let gradient = CAGradientLayer().backgroundGradientColor()
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        background.setNeedsLayout()
        background.layoutIfNeeded()
        
        if theme is LightTheme {
            gradient.frame = self.view.frame
            self.view.backgroundColor = .clear
            self.view.layer.insertSublayer(gradient, at: 0)
            
        } else {
            self.view.backgroundColor = theme.backgroundColor
            gradient.removeFromSuperlayer()
            
        }
    }
    
    @objc func checkPressed() {
        checkButton.checked = !checkButton.checked
        
        if checkButton.checked == true {
            checkButton.setImage(#imageLiteral(resourceName: "checked_box"), for: .normal)
            registerButton.isEnabled = true
        } else {
            checkButton.setImage(#imageLiteral(resourceName: "unchecked_box"), for: .normal)
            registerButton.isEnabled = false
        }
    }
    
    @objc func showTerms() {
        self.navigationController?.navigationBar.isHidden = false
        guard let termsViewController = UIStoryboard(name: "TermsOfUse", bundle: nil)
            .instantiateViewController(withIdentifier: "TermsOfUseViewController")
            as? TermsOfUseViewController else {
                print("LOG: Could not load TermsOfUse storyboard")
                return
        }
        
        self.navigationController?.pushViewController(termsViewController, animated: true)
    }
    
    @objc func register() {
        UserDefaultsManager.setAcceptedTermsOfUse(accepted: checkButton.checked)
        
        if checkButton.checked {
            let user = LocalUser(userID: nil,
                                 name: nameFormView.formTextField.text,
                                 email: emailFormView.formTextField.text,
                                 age: TimeFormat.date(str: birthDateFormView.formTextField.text ?? ""),
                                 city: cityFormView.formTextField.text,
                                 state: stateFormView.formTextField.text,
                                 descriptionID: nil,
                                 acceptedTerms: UserDefaultsManager.getAcceptedTermsOfUse(),
                                 reported: false)
            
            presenter.handleNewUser(userInfo: user,
                                    passwords: (passwordFormView.formTextField.text,
                                                confirmPasswordFormView.formTextField.text)) { (error) in
                                                    print(error)
                                                    self.presentAlert(message: error.description)
            }
        }
    }

    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Informações faltando", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    @objc func showLogin() {
        let navController = UINavigationController(rootViewController: LoginViewController())
        presenter.navigateTo(viewController: navController)
    }
}
