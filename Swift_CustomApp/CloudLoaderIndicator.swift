//
//  CloudLoaderIndicator.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/22/21.
//

import UIKit

@IBDesignable
public final class CloudLoaderIndicator : UIView {
    
    let shapePath: UIBezierPath = {
        var shape = UIBezierPath()
        shape.move(to: CGPoint(x: 41, y: 170.3))
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
        
        shape = shape.reversing()
        
        return shape
    }()
    
    var pathLayer = CAShapeLayer()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupLayer()
    }
    
    private func setupLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.lightGray.cgColor
        shapeLayer.path = shapePath.cgPath
        shapeLayer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.blue.cgColor
        pathLayer.path = shapePath.cgPath
        pathLayer.lineWidth = 15
        pathLayer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        pathLayer.strokeEnd = 0
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(pathLayer)
        
      
    }
    
    func startAnimating() {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        
        pathAnimation.speed = 0.1
        pathAnimation.repeatCount = Float.infinity

        pathLayer.add(pathAnimation, forKey: nil)
    }
}
