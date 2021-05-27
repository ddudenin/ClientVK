//
//  CloudLoaderIndicator.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 22.02.2021.
//

import UIKit

public final class CloudLoaderIndicator : UIView {
    
    private let cloudPath: UIBezierPath = {
        var shape = UIBezierPath()
        shape.move(to: CGPoint(x: 99.8, y: 170.3))
        shape.addLine(to: CGPoint(x: 158.6, y: 170.3))
        shape.addCurve(to: CGPoint(x: 200, y: 129.3), controlPoint1: CGPoint(x: 179.6, y: 170.3), controlPoint2: CGPoint(x: 200, y: 147.7))
        shape.addCurve(to: CGPoint(x: 175.3, y: 92), controlPoint1: CGPoint(x: 200, y: 113.2), controlPoint2: CGPoint(x: 190.2, y: 98.6))
        shape.addCurve(to: CGPoint(x: 123.4, y: 29.7), controlPoint1: CGPoint(x: 181.3, y: 59.5), controlPoint2: CGPoint(x: 142.5, y: 29.7))
        shape.addCurve(to: CGPoint(x: 78.2, y: 55.3), controlPoint1: CGPoint(x: 104.5, y: 29.7), controlPoint2: CGPoint(x: 87.5, y: 45.3))
        shape.addCurve(to: CGPoint(x: 41.6, y: 60.4), controlPoint1: CGPoint(x: 65.5, y: 51.2), controlPoint2: CGPoint(x: 52.4, y: 52.9))
        shape.addCurve(to: CGPoint(x: 23.9, y: 92.4), controlPoint1: CGPoint(x: 30.8, y: 67.8), controlPoint2: CGPoint(x: 24.4, y: 79.6))
        shape.addCurve(to: CGPoint(x: 0, y: 129.3), controlPoint1: CGPoint(x: 9.4, y: 99.2), controlPoint2: CGPoint(x: 0, y: 113.5))
        shape.addCurve(to: CGPoint(x: 0.8, y: 137.3), controlPoint1: CGPoint(x: 0.8, y: 132), controlPoint2: CGPoint(x: 0.3, y: 123.9))
        shape.addCurve(to: CGPoint(x: 41, y: 170.3), controlPoint1: CGPoint(x: 4.6, y: 151.1), controlPoint2: CGPoint(x: 21.5, y: 170.3))
        shape.addLine(to: CGPoint(x: 99.8, y: 170.3))
        
        shape = shape.reversing()
        
        return shape
    }()
    
    private var pathLayer = CAShapeLayer()
    private let shapeLayer = CAShapeLayer()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupLayer()
    }
    
    private func setupLayer() {
        let scaleTransform = CATransform3DMakeScale(0.25, 0.25, 1)
        
        self.shapeLayer.fillColor = UIColor.lightGray.cgColor
        self.shapeLayer.strokeColor = UIColor.clear.cgColor
        self.shapeLayer.path = self.cloudPath.cgPath
        self.shapeLayer.transform = scaleTransform
        self.shapeLayer.opacity = 0
        
        self.pathLayer.fillColor = UIColor.clear.cgColor
        self.pathLayer.strokeColor = UIColor.systemBlue.cgColor
        self.pathLayer.path = self.cloudPath.cgPath
        self.pathLayer.lineWidth = 10
        self.pathLayer.transform = scaleTransform
        self.pathLayer.strokeEnd = 0
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(self.pathLayer)
    }
    
    func startAnimation(completion: ((Bool) -> Void)?) {
        CATransaction.begin()
        
        let strokeEndAnimation: CAAnimation = {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 20
            
            let group = CAAnimationGroup()
            group.duration = 20
            group.repeatCount = 2
            group.animations = [animation]
            return group
        }()
        
        let strokeStartAnimation: CAAnimation = {
            let animation = CABasicAnimation(keyPath: "strokeStart")
            animation.beginTime = 2
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 20
            
            let group = CAAnimationGroup()
            group.duration = 20
            group.repeatCount = 2
            group.animations = [animation]
            return group
        }()
        
        let animationGroup = CAAnimationGroup()
        animationGroup.repeatCount = 1
        animationGroup.speed = 7
        animationGroup.duration = strokeEndAnimation.duration * Double(animationGroup.repeatCount) + strokeStartAnimation.duration * Double(animationGroup.repeatCount)
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        
        CATransaction.setCompletionBlock {
            if let completionBlock = completion {
                completionBlock(true)
                self.shapeLayer.opacity = 0
            }
        }
        
        self.pathLayer.add(animationGroup, forKey: "myStroke")
        CATransaction.commit()
    }
    
    func animate(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 1.5,
                       animations: {
                        self.shapeLayer.opacity = 1
                       },
                       completion: { _ in
                        self.startAnimation(completion: completion)
                       })
    }
}
