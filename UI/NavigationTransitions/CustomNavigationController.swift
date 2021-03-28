//
//  CustomNavigationController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/23/21.
//

import UIKit

class CustomNavigationController: UINavigationController {
    let interactiveTransition = CustomInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.delegate = self
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            self.interactiveTransition.viewController = toVC
            return CustomPushAnimator()
        case .pop:
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return CustomPopAnimator()
        default:
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.interactionInProgress ? interactiveTransition : nil
    }
}
