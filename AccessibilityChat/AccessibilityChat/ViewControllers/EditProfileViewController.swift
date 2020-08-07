//
//  EditProfileViewController.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/6/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Cartography

class EditProfileViewController: ACViewController {
    let theme: Theme = UserDefaultsManager.getTheme()

    let scrollView = UIScrollView()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.backgroundColor = .black
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = theme.primaryCellBackgroundColor
        view.textAlignment = .center
        view.font = UIFont(name: "Stilu-bold", size: 24)
        view.text = "Andressa Aquino"
        view.textColor = theme.editProfileLabelsColor
        return view
    }()
    
    lazy var dateTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = theme.secondaryCellBackgroundColor
        view.textAlignment = .center
        view.font = UIFont(name: "Stilu-bold", size: 24)
        view.text = "01/04/1996"
        view.textColor = theme.editProfileLabelsColor
        return view
    }()
    
    lazy var stateTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = theme.primaryCellBackgroundColor
        view.textAlignment = .center
        view.font = UIFont(name: "Stilu-bold", size: 24)
        view.text = "São Paulo"
        view.textColor = theme.editProfileLabelsColor
        return view
    }()
    
    lazy var cityTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = theme.secondaryCellBackgroundColor
        view.textAlignment = .center
        view.font = UIFont(name: "Stilu-bold", size: 24)
        view.text = "Campinas"
        view.textColor = theme.editProfileLabelsColor
        return view
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.editProfileSeparatorColor
        view.layer.cornerRadius = 4
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }
    
    func setupInitialState() {
        addSubviews()
        setupScrollView()
        setupStackView()
        setupTextFields()
    }

    func addSubviews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(dateTextField)
        stackView.addArrangedSubview(stateTextField)
        stackView.addArrangedSubview(cityTextField)
        scrollView.addSubview(separatorView)
    }
    
    func setupTextFields() {
        constrain(nameTextField, dateTextField, stateTextField,
                  cityTextField) { name, date, state, city in
            name.width == name.superview!.width
            name.height == 140
            name.centerX == name.superview!.centerX
            date.width == name.superview!.width
            date.height == 140
            date.centerX == name.superview!.centerX
            state.width == name.superview!.width
            state.height == 140
            state.centerX == name.superview!.centerX
            city.width == name.superview!.width
            city.height == 140
            city.centerX == name.superview!.centerX
        }
        
        if theme is DarkTheme {
            stackView.spacing = -2
            nameTextField.layer.borderColor = theme.cellBorderColor.cgColor
            nameTextField.layer.borderWidth = 4
            dateTextField.layer.borderColor = theme.cellBorderColor.cgColor
            dateTextField.layer.borderWidth = 4
            cityTextField.layer.borderColor = theme.cellBorderColor.cgColor
            cityTextField.layer.borderWidth = 4
            stateTextField.layer.borderColor = theme.cellBorderColor.cgColor
            stateTextField.layer.borderWidth = 4
        } else {
            stackView.spacing = 0
        }
    }

    func setupCell(cell: UIView, textField: UITextField) {
        cell.addSubview(textField)

        constrain(cell, textField) { background, textfield in
            guard let superview = background.superview else { return }
            background.height == 140
            background.width == superview.width
            background.centerX == superview.centerX
            textfield.center == background.center
        }
    }
    
    func setupScrollView() {
        constrain(scrollView) { scrollView in
            guard let superview = scrollView.superview else { return }
            scrollView.left == superview.left
            scrollView.right == superview.right
            scrollView.width == superview.width
            scrollView.bottom == superview.bottom
            scrollView.top == superview.top
        }
    }

    func setupStackView() {
        constrain(stackView) { view in
            guard let superview = view.superview else { return }
            view.width == superview.width
            view.left == superview.left
            view.right == superview.right
            view.top == superview.top
        }
    }

}

class EditProfileTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

//extension EditProfileViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        constrain(textField, separatorView) { textField, separator in
//            separator.height == 6
//            separator.top == textField.bottom - (140 * 0.35)
//            separator.right == separator.superview!.right + 10
//        }
//
//        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
//            constrain(self.separatorView) { separator in
//                separator.left == separator.superview!.left + 38
//            }
//        })
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
//            constrain(self.separatorView) { separator in
//                separator.left == separator.superview!.right
//            }
//        })
//    }
//}
