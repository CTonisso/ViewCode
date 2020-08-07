//
//  TermsOfUseViewController.swift
//  AccessibilityChat
//
//  Created by Julianny Favinha on 12/7/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class TermsOfUseViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theme = UserDefaultsManager.getTheme()
        self.view.backgroundColor = theme.backgroundColor
        self.textView.textColor = theme.currentThemeTitleColor
        self.textView.isAccessibilityElement = true
        
        guard let htmlFile = NSDataAsset(name: "TermsOfUse")?.data else {
            print("LOG: Problems in get TermsOfUse.html file")
            return
        }
        
        if let htmlText = String(data: htmlFile, encoding: String.Encoding.utf8) {
            textView.text = htmlText.html2String
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}

extension String {
    public var html2AttributedString: NSAttributedString? {
        do {
            let newString = "<span style=\"font-family: -apple-system; font-size: 14\">\(self)</span>"
            guard let stringData = newString.data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(
                data: stringData,
                options:
                [NSAttributedString.DocumentReadingOptionKey.documentType:
                    NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
        } catch {
            print("error:", error)
            return  nil
        }
    }
    
    public var html2String: String {
        let string = html2AttributedString?.string ?? ""
        return string
    }
}
