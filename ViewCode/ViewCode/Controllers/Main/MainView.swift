//
//  MainView.swift
//  ViewCode
//
//  Created by Carlos Marcelo Tonisso Junior on 03/08/20.
//  Copyright © 2020 Carlos Marcelo Tonisso Junior. All rights reserved.
//

import Foundation
import UIKit

class MainView: UIView {

    let cardView: CardView
    
    init() {
        cardView = CardView(title: "Este é o título", subtitle: "Este é o subtítulo")
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainView: ViewCodable {

    func buildView() {
        addSubview(cardView)
    }
    
    func setupConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            cardView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            cardView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            cardView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setupAdditionalConfig() {
        self.backgroundColor = .white
        cardView.backgroundColor = .lightGray
    }
    
}
