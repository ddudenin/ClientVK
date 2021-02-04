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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.borderWidth = 1
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setFillColor(UIColor.blue.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
    }
}
