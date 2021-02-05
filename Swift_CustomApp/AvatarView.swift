//
//  AvatarView.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/3/21.
//

import UIKit

@IBDesignable class AvatarView: UIView {
    
    @IBInspectable public var shadowWidth: CGFloat = 4.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .cyan {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOffset: Float = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    let containerView = UIView()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let cornerRadius = self.frame.width / 2

        self.backgroundColor = .red
        let maskLayer = CAShapeLayer()
        let starPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
        maskLayer.path = starPath.cgPath
        
        maskLayer.shadowColor = UIColor.black.cgColor
        maskLayer.shadowOpacity = shadowOffset
        maskLayer.shadowRadius = 2*cornerRadius
        maskLayer.shadowOffset = CGSize(width: 10, height: 10)

        self.layer.mask = maskLayer
        
        //guard let context = UIGraphicsGetCurrentContext() else { return }
        
        //context.setFillColor(UIColor.blue.cgColor)
        //context.fill(CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
    }
}
