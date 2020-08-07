//
//  CardView.swift
//  ViewCode
//
//  Created by Carlos Marcelo Tonisso Junior on 07/08/20.
//  Copyright © 2020 Carlos Marcelo Tonisso Junior. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var title: UILabel
    var subtitle: UILabel
    
    init(title: String, subtitle: String) {
        self.title = UILabel()
        self.subtitle = UILabel()
        super.init(frame: .zero)
        self.title.text = title
        self.subtitle.text = subtitle
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CardView: ViewCodable {

    func buildView() {
        addSubview(title)
        addSubview(subtitle)
    }
    
    func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            title.heightAnchor.constraint(equalToConstant: 32),
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.widthAnchor.constraint(equalTo: self.widthAnchor),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            subtitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subtitle.heightAnchor.constraint(equalToConstant: 16),
            subtitle.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    func setupAdditionalConfig() {
        self.layer.cornerRadius = 8
        title.font = UIFont.systemFont(ofSize: 24)
        title.textColor = .black
        title.textAlignment = .center
        subtitle.font = UIFont.systemFont(ofSize: 12)
        subtitle.textColor = .gray
        subtitle.textAlignment = .center
    }
    
    
}
