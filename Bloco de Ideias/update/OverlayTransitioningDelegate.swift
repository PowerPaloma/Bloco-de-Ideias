//
//  OverlayTransitioningDelegate.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 25/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class OverlayTransitioningDelegate : NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return OverlayPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BouncyViewControllerAnimator(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BouncyViewControllerAnimator()
    }
}
