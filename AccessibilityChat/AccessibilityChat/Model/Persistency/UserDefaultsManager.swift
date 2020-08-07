//
//  UserDefaultsManager.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 10/25/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case theme
    case didChoseTheme
    case numberOfExecutions
    case acceptedTermsOfUse
}

class UserDefaultsManager {
    static var defaults = UserDefaults.standard

    class func setTheme(to themeType: ThemeType) {
        defaults.set(themeType.rawValue, forKey: UserDefaultsKeys.theme.rawValue)
    }

    class func getTheme() -> Theme {
        if let modeRawValue = defaults.string(forKey:
            UserDefaultsKeys.theme.rawValue) {
            if modeRawValue == "dark" {
                return DarkTheme()
            }
        }

        return LightTheme()
    }
    
    class func getThemeType() -> ThemeType {
        if let modeRawValue = defaults.string(forKey:
            UserDefaultsKeys.theme.rawValue) {
            if modeRawValue == "dark" {
                return ThemeType.dark
            }
        }
        
        return ThemeType.light
    }
    
    class func updateNumberOfExecutions() {
        let key = UserDefaultsKeys.numberOfExecutions.rawValue
        defaults.set(defaults.integer(forKey: key) + 1, forKey: key)
    }
    
    class func getNumberOfExecutions() -> Int {
        return defaults.integer(forKey: UserDefaultsKeys.numberOfExecutions.rawValue)
    }
    
    class func setDidChoseTheme(flag: Bool) {
        let key = UserDefaultsKeys.didChoseTheme.rawValue
        defaults.set(flag, forKey: key)
    }
    
    class func getDidChoseTheme() -> Bool {
        return defaults.bool(forKey: UserDefaultsKeys.didChoseTheme.rawValue)
    }
    
    class func setAcceptedTermsOfUse(accepted: Bool) {
        let key = UserDefaultsKeys.acceptedTermsOfUse.rawValue
        defaults.set(accepted, forKey: key)
    }
    
    class func getAcceptedTermsOfUse() -> Bool {
        return defaults.bool(forKey: UserDefaultsKeys.acceptedTermsOfUse.rawValue)
    }
}
