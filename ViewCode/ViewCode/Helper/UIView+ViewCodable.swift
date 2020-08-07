//
//  UIView+ViewCodable.swift
//  ViewCode
//
//  Created by Carlos Marcelo Tonisso Junior on 07/08/20.
//  Copyright © 2020 Carlos Marcelo Tonisso Junior. All rights reserved.
//

import Foundation

protocol ViewCodable {
    func buildView()
    func setupConstraints()
    func setupAdditionalConfig()
    func setupView()
}

extension ViewCodable {
    func setupView(){
        buildView()
        setupConstraints()
        setupAdditionalConfig()
    }
}
