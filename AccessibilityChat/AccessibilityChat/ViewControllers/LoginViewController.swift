//
//  LoginViewController.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/27/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Cartography
import Firebase

class LoginViewController: ACViewController {
    let theme: Theme = UserDefaultsManager.getTheme()
    
    let presenter = LoginPresenter()
    
    lazy var scrollView = UIScrollView()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 30
        stack.backgroundColor = .clear
        return stack
    }()
    
    lazy var appLogoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "waves")!
        return image
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
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.backgroundColor = theme.registerButtonColor
        button.setTitleColor(theme.registerButtonTitleColor, for: .normal)
        button.setTitle("Entrar", for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-bold", size: 24)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Esqueci a senha", for: .normal)
        button.setTitleColor(theme.formFieldLabelColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-bold", size: 20)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Não tem conta? Cadastrar", for: .normal)
        button.setTitleColor(theme.formFieldLabelColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-bold", size: 20)
        button.addTarget(self, action: #selector(showRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Voltar", for: .normal)
        button.setTitleColor(theme.formFieldLabelColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-bold", size: 20)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        
        setupInitialState()
    }
    
    func setupInitialState() {
        addSubViews()
        setupBackground()
        setupScrollView()
        setupStackView()
        setupLogoImageView()
        setupLoginButton()
        setupLabelButtons()
        setupTextFields()
    }
    
    func addSubViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(appLogoImageView)
        stackView.addArrangedSubview(emailFormView)
        stackView.addArrangedSubview(passwordFormView)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(forgotPasswordButton)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(backButton)
    }
    
    func setupBackground() {
        
        let gradient = CAGradientLayer().backgroundGradientColor()
        
        if theme is LightTheme {
            gradient.frame = self.view.frame
            self.view.backgroundColor = .clear
            self.view.layer.insertSublayer(gradient, at: 0)
        } else {
            self.view.backgroundColor = theme.backgroundColor
            gradient.removeFromSuperlayer()
        }
    }
    
    func setupScrollView() {
        scrollView.backgroundColor = .clear
        
        constrain(scrollView) { view in
            guard let superview = view.superview else { return }
            view.edges == inset(superview.edges, 0, 0, 0, 0)
        }
    }
    
    func setupStackView() {
        constrain(stackView) { stack in
            guard let superview = stack.superview else { return }
            stack.width == superview.width - 32
            stack.top == superview.top
            stack.left == superview.left + 16
            stack.right == superview.right - 16
            stack.bottom == superview.bottom - 30
        }
    }
    
    func setupLogoImageView() {
        constrain(appLogoImageView) { view in
            guard let superview = view.superview else { return }
            view.height == 57
            view.width == superview.width
        }
    }
    
    func setupLoginButton() {
        loginButton.layer.cornerRadius = 9
        loginButton.layer.masksToBounds = true
        constrain(loginButton) { button in
            button.height == 50
            button.width == 170
        }
    }
    
    func setupTextFields() {
        constrain(emailFormView, passwordFormView) { email, password in
            guard let superview = email.superview else { return }
            email.width == superview.width
            email.centerX == superview.centerX
            password.width == superview.width
            password.centerX == superview.centerX
        }
    }
    
    func setupLabelButtons() {
        forgotPasswordButton.addTarget(self, action: #selector(showForgotPassword), for: .touchUpInside)
    }
    
    @objc func showRegister() {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @objc func showForgotPassword() {
//        presenter.navigateTo(viewController: ForgotPasswordViewController())
    }
    
    @objc func showTutorial() {
//        presenter.navigateTo(viewController: TutorialViewController())
    }
    
    @objc func login() {
        presenter.handleLogin(email: emailFormView.formTextField.text, password: passwordFormView.formTextField.text)
    }
}
