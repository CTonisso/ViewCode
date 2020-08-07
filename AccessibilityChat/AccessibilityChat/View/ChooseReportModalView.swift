//
//  ReportModalView.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 12/7/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Cartography

enum ReportTypes: String {
    case notInterested = "Não tenho interesse"
    case fakeProfile = "Perfil falso / Spam"
    case improperContent = "Conteúdo impróprio"
    case abusiveBehavior = "Comportamento abusivo"
    case violentBehavior = "Comportamento violento"
    case other = "Outro"
    case cancel = "Cancelar"
}

class ChooseReportModalView: UIView, Modal {
    
    let theme = UserDefaultsManager.getTheme()
    
    var user: LocalUser = LocalUser()

    weak var chatLogDelegate: ChatLogDelegate?
    
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
        label.text = "Denunciar essa pessoa"
        label.backgroundColor = theme.backgroundColor
        return label
    }()
    
    lazy var headerSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Stilu-SemiBold", size: 16)
        label.textAlignment = .center
        label.textColor = theme.errorLabelColor
        label.text = "Selecione uma das opções abaixo"
        label.backgroundColor = theme.backgroundColor
        return label
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
    
    func addErrorButton(user: LocalUser, type: ReportTypes) {
        let button = ReportButton()
        button.setTitleColor(theme.errorButtonColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Stilu-Bold", size: 20)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = theme.backgroundColor
        button.setTitle(type.rawValue, for: .normal)
        button.reportType = type
        button.reportUser = user
        if type != .cancel {
            button.addTarget(self, action: #selector(showReport(_:)), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        }
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        stackView.addArrangedSubview(button)
        
        constrain(button) { button in
            guard let superview = button.superview else { return }
            button.width == superview.width
            button.height == 60
        }
    }
    
    convenience init(user: LocalUser) {
        self.init(frame: UIScreen.main.bounds)
        self.user = user
        setupInitialState()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(headerSubtitleLabel)
        stackView.addArrangedSubview(headerView)
        addErrorButton(user: self.user, type: .notInterested)
        addErrorButton(user: self.user, type: .fakeProfile)
        addErrorButton(user: self.user, type: .improperContent)
        addErrorButton(user: self.user, type: .abusiveBehavior)
        addErrorButton(user: self.user, type: .violentBehavior)
        addErrorButton(user: self.user, type: .other)
        addErrorButton(user: self.user, type: .cancel)
    }
    
    func setupDialog() {
        constrain(dialogView) { view in
            guard let superview = view.superview else { return }
            view.top == superview.top + 58
            view.width == superview.width * 0.885
            view.centerX == superview.centerX
        }
    }
    
    func setupHeader() {
        constrain(headerView) { view in
            guard let superview = view.superview else { return }
            view.width == superview.width
        }
        
        constrain(headerTitleLabel, headerSubtitleLabel) { title, subtitle in
            guard let superview = title.superview else { return }
            title.top == superview.top + 36
            title.centerX == superview.centerX
            subtitle.top == title.bottom + 16
            subtitle.centerX == superview.centerX
            subtitle.bottom == superview.bottom - 36
        }
    }
    
    func setupStackView() {
        constrain(stackView) { view in
            guard let superview = view.superview else { return }
            view.edges == inset(superview.edges, 5, 5, 5, 5)
        }
    }
    
    @objc func showReport(_ sender: Any) {
        let button = sender as? ReportButton
        let type = button?.reportType
        let user = button?.reportUser
        guard let reportType = type else { return }
        guard let reportUser = user else { return }
        let reportView = ReportModalView(user: reportUser, reportType: reportType)
        reportView.show(animated: true)
        reportView.chatLogDelegate = chatLogDelegate
    }
    
    @objc func dismissAlert() {
        self.dismiss(animated: true)
    }

    @objc func cancelAction() {
        chatLogDelegate?.returnToChatLog()
    }
}
