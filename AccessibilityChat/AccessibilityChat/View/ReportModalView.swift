//
//  ReportModalView.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 12/7/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Cartography

class ReportModalView: UIView, Modal {

    let theme = UserDefaultsManager.getTheme()
    
    lazy var reportType: ReportTypes = ReportTypes.cancel
    lazy var user: LocalUser = LocalUser()
    
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
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.backgroundColor
        return view
    }()
    
    lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Stilu-Bold", size: 20)
        label.textAlignment = .center
        label.textColor = theme.errorLabelColor
        label.text = "Conte-nos porque"
        label.backgroundColor = theme.backgroundColor
        return label
    }()
    
    lazy var headerSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Stilu-SemiBold", size: 16)
        label.textAlignment = .center
        label.textColor = theme.errorLabelColor
        label.backgroundColor = theme.backgroundColor
        return label
    }()
    
    lazy var headerTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Adicione um comentário"
        view.font = UIFont(name: "Stilu-SemiBold", size: 16)
        view.backgroundColor = .white
        view.textColor = theme.errorTextFieldColor
        if theme is LightTheme {
            view.layer.borderWidth = 3
            view.layer.borderColor = theme.errorLabelColor.cgColor
        }
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0)
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = theme.backgroundColor
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var reportButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(theme.errorButtonColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-Bold", size: 20)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = theme.backgroundColor
        button.setTitle("Reportar", for: .normal)
        button.addTarget(self, action: #selector(sendReport), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(theme.errorButtonColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-Bold", size: 20)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = theme.backgroundColor
        button.setTitle("Cancelar", for: .normal)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        return button
    }()

    weak var chatLogDelegate: ChatLogDelegate?

    convenience init(user: LocalUser, reportType: ReportTypes) {
        self.init(frame: UIScreen.main.bounds)
        setupInitialState()
        self.user = user
        self.reportType = reportType
        self.headerSubtitleLabel.text = reportType.rawValue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupInitialState() {
        addSubviews()
        setupDialog()
        setupHeader()
        setupStackView()
    }
    
    func addSubviews() {
        self.addSubview(backgroundView)
        self.addSubview(dialogView)
        dialogView.addSubview(stackView)
    }
    
    func setupHeader() {
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(headerSubtitleLabel)
        headerView.addSubview(headerTextField)
        constrain(headerTitleLabel, headerSubtitleLabel, headerTextField) { title, subtitle, textField in
            guard let superview = title.superview else { return }
            title.top == superview.top + 32
            title.centerX == superview.centerX
            subtitle.top == title.bottom + 10
            subtitle.centerX == superview.centerX
            textField.top == subtitle.bottom + 26
            textField.height == 38
            textField.bottom == superview.bottom - 26
            textField.width == superview.width * 0.85
            textField.centerX == superview.centerX
        }
        headerView.backgroundColor = theme.backgroundColor
        headerTextField.layer.cornerRadius = 19
    }
    
    func setupDialog() {
        constrain(dialogView) { view in
            guard let superview = view.superview else { return }
            view.top == superview.top + 190
            view.width == superview.width * 0.885
            view.centerX == superview.centerX
        }
    }
    
    func setupStackView() {
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(reportButton)
        stackView.addArrangedSubview(cancelButton)
        constrain(stackView) { view in
            guard let superview = view.superview else { return }
            view.edges == inset(superview.edges, 5, 5, 5, 5)
        }
        
        constrain(headerView, reportButton, cancelButton) { header, report, cancel in
            guard let superview = header.superview else { return }
            header.width == superview.width
            report.width == superview.width
            cancel.width == superview.width
            report.height == 60
            cancel.height == 60
        }
    }
    
    @objc func sendReport() {
        ReportServices().report(user: self.user, reportType: self.reportType.rawValue,
                                comment: headerTextField.text ?? "") { (error) in
            if error != nil {
                print(error!)
            } else {
                DispatchQueue.main.async {
                    self.dismissAlert()
                }
            }
        }
    }
    
    @objc func dismissAlert() {
        self.dismiss(animated: true)
        chatLogDelegate?.returnToChatLog()
    }
}
