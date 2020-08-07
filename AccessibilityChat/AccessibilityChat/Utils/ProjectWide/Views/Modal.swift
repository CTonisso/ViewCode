//
//  Modal.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/29/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import UIKit

protocol Modal {
    func show(animated: Bool)
    func dismiss(animated: Bool)
    var backgroundView: UIView { get }
    var dialogView: UIView { get set }
}

extension Modal where Self: UIView {
    func show(animated: Bool) {
        self.backgroundView.alpha = 0
        self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height / 2)
        UIApplication.shared.delegate?.window??.rootViewController?.view.addSubview(self)
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 1
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 10,
                           options: UIView.AnimationOptions(rawValue: 0),
                           animations: {
                self.dialogView.center  = self.center
            }, completion: { (completed) in
                print("Completed: \(completed)")
            })
        } else {
            self.backgroundView.alpha = 1
            self.dialogView.center  = self.center
        }
    }
    
    func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: { (completed) in
                 print("Completed: \(completed)")
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1,
                           initialSpringVelocity: 10,
                           options: UIView.AnimationOptions(rawValue: 0),
                           animations: {
                self.dialogView.center = CGPoint(x: self.center.x,
                                                 y: self.frame.height + self.dialogView.frame.height / 2)
            }, completion: { (completed) in
                print("Completed: \(completed)")
                self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }
        
    }
}
