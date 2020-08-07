//
//  NavigationHelper.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/27/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Foundation

class NavigationHelper {
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    static let shared = NavigationHelper()
    
    enum ACAnimation {
        case revealFromTop
        case slideFromRight
        case fade
    }
    
    func switchRootViewController(to viewController: UIViewController?, withAnimation animation: ACAnimation?) {
        
        guard let appDelegate = appDelegate else { return }
        
        guard let viewController = viewController else { return }
        
        guard let appDelegateWindow = appDelegate.window,
            let appDelegateView = appDelegateWindow.rootViewController?.view,
            let viewContollersView = viewController.view else {
                return
        }
        
        viewContollersView.frame = appDelegateWindow.bounds
        appDelegateWindow.addSubview(viewContollersView)
        
        if animation != nil {
            let transition = getTransitionAnimation(animation!)
            appDelegateView.layer.add(transition, forKey: "transition")
            viewContollersView.layer.add(transition, forKey: "transition")
            appDelegateView.isHidden = true
            viewContollersView.isHidden = false
        }
        
        appDelegateWindow.rootViewController = viewController
        
        appDelegateWindow.makeKeyAndVisible()
    }
    
    private func getTransitionAnimation(_ animation: ACAnimation) -> CATransition {
        let transition = CATransition()
        
        switch animation {
        case .revealFromTop:
            transition.startProgress = 0
            transition.endProgress = 1.0
            transition.type = .reveal
            transition.subtype = .fromTop
            transition.duration = 0.45
            
        case .fade:
            transition.startProgress = 0
            transition.endProgress = 1.0
            transition.type = .fade
            transition.subtype = .fromTop
            transition.duration = 0.45
            
        case .slideFromRight:
            transition.startProgress = 0
            transition.endProgress = 1.0
            transition.type = .push
            transition.subtype = .fromRight
            transition.duration = 0.45
            
        }
        
        return transition
    }
    
}
