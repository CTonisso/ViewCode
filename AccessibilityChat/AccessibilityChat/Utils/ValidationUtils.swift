//
//  ValidationUtils.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 11/29/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation

class ValidationUtils {
    
    public init() {}
    
    static func isValidEmail(testStr: String?) -> Bool {
        guard let testStr = testStr else { return false }
        let test = testStr.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: test)
    }
    
    static func isValidCPF(str: String?) -> Bool {
        guard let cpf = str else { return false }
        return digitsOnly(str: cpf).count == 11
    }
    
    static func isValidCNPJ(str: String?) -> Bool {
        guard let cnpj = str else { return false }
        return digitsOnly(str: cnpj).count == 12
    }
    
    static func isValidPhoneNumber(str: String?) -> Bool {
        guard let phone = str else { return false }
        return digitsOnly(str: phone).count >= 10
    }
    
    static func isCEPValid(str: String?) -> Bool {
        guard let cep = str else { return false }
        return digitsOnly(str: cep).count == 8
    }
    
    static func isValidItem(str: String?) -> Bool {
        guard let str = str else { return false }
        return !str.isEmpty
    }
    
    private static func digitsOnly(str: String) -> String {
        let numberComponents = str.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        return numberComponents.joined(separator: "")
    }
}
