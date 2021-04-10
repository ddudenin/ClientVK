//
//  CustomInteractiveTransition.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/23/21.
//

import UIKit

final class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    
    var shouldCompleteTransition = false
    var viewController: UIViewController? {
        didSet {
            prepareGestureRecognizer(in: viewController?.view)
        }
    }

    private func prepareGestureRecognizer(in view: UIView?) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgeGesture(_:)))
        view?.addGestureRecognizer(gesture)
    }
    
    @objc private func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view?.superview)
        var progress = translation.x / (recognizer.view?.bounds.width ?? 1)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
                
        switch recognizer.state {
        case .began:
            self.interactionInProgress = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            self.shouldCompleteTransition = progress > 0.33
            self.update(CGFloat(progress))
        case .ended:
            self.interactionInProgress = false
            self.shouldCompleteTransition ? self.finish() : self.cancel()
        case .cancelled:
            self.interactionInProgress = false
            self.cancel()
        default:
            break
        }
    }
    
    
    
}
