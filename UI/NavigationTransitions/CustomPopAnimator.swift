//
//  CustomPushAnimator.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 23.02.2021.
//

import UIKit

final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        
        source.view.setAnchorPoint(CGPoint(x: 1, y: 0))
        destination.view.frame = source.view.frame
        destination.view.setAnchorPoint(CGPoint(x: 1, y: 0))
        
        let angle90 =  CGFloat.pi / 2
        destination.view.transform = CGAffineTransform(rotationAngle: angle90)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.75,
                                                       animations: {
                                                        source.view.transform = CGAffineTransform(rotationAngle: -angle90)
                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0.45,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        destination.view.transform = CGAffineTransform(rotationAngle: 0)
                                                       })
                                })
        { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
}
