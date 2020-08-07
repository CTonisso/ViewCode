//
//  CAGradientLayer+BackgroundGradientColor.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/1/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func backgroundGradientColor() -> CAGradientLayer {
        
        let theme: Theme = UserDefaultsManager.getTheme()
        
        let gradientColors: [CGColor] = [theme.gradientColors[0].cgColor,
                                         theme.gradientColors[1].cgColor,
                                         theme.gradientColors[2].cgColor]
        let gradientLocations: [NSNumber]!
        
        if theme is LightTheme {
            gradientLocations = [0.0, 0.7, 1.0]
        } else {
            gradientLocations = [0.0, 0.23, 1.0]
        }
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
        
    }
}
