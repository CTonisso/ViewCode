//
//  AccessibilityChatTextField.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/3/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import SwiftMaskTextfield

class AccessibilityChatTextField: UITextField {

    public override init(frame: CGRect) {
        maskTextField = SwiftMaskTextField()
        super.init(frame: frame)
        setupMaskConfigs()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        maskTextField = SwiftMaskTextField()
        super.init(coder: aDecoder)
        setupMaskConfigs()
    }
    
    // MARK: - Swift Mask Configuration
    
    private var maskTextField: SwiftMaskTextField
    
    public var formatPattern: String? = nil {
        didSet {
            maskTextField.formatPattern = formatPattern ?? ""
        }
    }
    
    open override var text: String? {
        set {
            if formatPattern != nil {
                maskTextField.text = newValue
                maskTextField.formatText()
                super.text = maskTextField.text
            } else {
                super.text = newValue
            }
        } get {
            return super.text
        }
    }
    
    fileprivate func setupMaskConfigs() {
        self.registerForNotifications()
    }
    
    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: NSNotification.Name(
                rawValue: "UITextFieldTextDidChangeNotification"),
            object: self)
    }
    
    @objc fileprivate func textDidChange() {
        self.undoManager?.removeAllActions()
        text = super.text
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
