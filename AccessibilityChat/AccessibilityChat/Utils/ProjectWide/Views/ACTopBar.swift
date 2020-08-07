//
//  ACTopBar.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/14/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Foundation
import Cartography

protocol TopBarDelegate: AnyObject {
    func didTapBackButton()
    func didTapCloseButton()
}

extension TopBarDelegate {
    func didTapBackButton() {}
    func didTapCloseButton() {}
}

class ACTopBar: UIView {
    
    let theme = UserDefaultsManager.getTheme()

    private var titleLabel: UILabel?
    private var backButton: UIButton?
    private var doneButton: UIButton?
    private var closeButton: UIButton?
    private var stackView: UIStackView = { UIStackView() }()
    private var backgroundView: UIView?

    weak var delegate: TopBarDelegate?
    
    enum Config {
        case titleLabel(text: String, aligment: NSTextAlignment)
        case backButton(title: String)
        case titleLogo
        case closeButton
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitialState()
    }
    
    // MARK: - View Configuration Methods
    
    private func setupInitialState() {
        configureBackgroundView()
        configureStackView()
    }
    
    private func configureBackgroundView() {
        backgroundView = UIView()
        backgroundView?.backgroundColor = theme.topbarBackgroundColor
        addSubview(backgroundView!)
        constrain(backgroundView!) { (view) in
            view.edges == view.superview!.edges
        }
    }
    
    private func configureStackView() {
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.alignment = .center
        addSubview(stackView)
        constrain(stackView) { (stack) in
            guard let superview = stack.superview else { return }
            stack.top == superview.topMargin
            stack.bottom == superview.bottom
            stack.left == superview.left + 8
            stack.right == superview.right - 8
        }
    }
    
}
