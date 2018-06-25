//
//  BouncyViewControllerAnimator.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 25/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

import UIKit

class BouncyViewControllerAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool = false
    
    convenience init(isPresenting: Bool = false) {
        self.init()
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view else { return }
        guard let toView = transitionContext.viewController(forKey: .to)?.view else { return }
        
        var center = toView.center
        
        if isPresenting {
            toView.center.y = toView.bounds.size.height
            transitionContext.containerView.addSubview(toView)
        } else {
            center.y = toView.bounds.size.height + fromView.bounds.size.height
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 300,
                       initialSpringVelocity: 10.0,
                       options: [],
                       animations: {
                        if self.isPresenting {
                            toView.center = center
                            fromView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                        } else {
                            fromView.center = center
                            toView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        }
        }) { _ in
            if !self.isPresenting {
                fromView.removeFromSuperview()
            }
            
            transitionContext.completeTransition(true)
        }
    }
}
