//
//  SettingsTableViewCell.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 12/3/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    let theme: Theme = UserDefaultsManager.getTheme()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.setupAdjustableFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title: String, color: UIColor) {
        self.titleLabel.text = title
        self.titleLabel.textColor = color
        self.backgroundColor = theme.backgroundColor
    }

}
