//
//  Dot.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/17/21.
//

import UIKit

@IBDesignable
public final class DotsLoadingIndicator : UIView {
    
    private var dotLayers = [CAShapeLayer]()
    private var dotsOpacity = 1.0

    @IBInspectable public var dotsCount: Int = 3 {
        didSet {
            self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            self.dotLayers.removeAll()
            self.setupLayers()
        }
    }
    
    @IBInspectable public var dotsRadius: CGFloat = 7.0 {
        didSet {
            for layer in self.dotLayers {
                layer.bounds = CGRect(origin: .zero, size: CGSize(width: self.dotsRadius * 2.0, height: self.dotsRadius * 2.0))
                layer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: self.dotsRadius).cgPath
            }
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var dotsSpacing: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override public var tintColor: UIColor! {
        didSet {
            for layer in self.dotLayers {
                layer.fillColor = self.tintColor.cgColor
            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupLayers()
    }
    
    public func startAnimating() {
        var offset: TimeInterval = 0.0
        self.dotLayers.forEach {
            $0.removeAllAnimations()
            $0.add(animate(offset), forKey: "opacityAnimation")
            offset = offset + 0.2
        }
    }
    
    public func stopAnimating() {
        self.dotLayers.forEach { $0.removeAllAnimations() }
    }
    

    public override func layoutSubviews() {
        super.layoutSubviews()
    
        let center = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
        let middle: Int = self.dotsCount / 2
        for (index, layer) in self.dotLayers.enumerated() {
            let x = center.x + CGFloat(index - middle) * ((self.dotsRadius * 2) + self.dotsSpacing)
            layer.position = CGPoint(x: x, y: center.y)
        }
    }
    
    private func dotLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.bounds = CGRect(origin: .zero, size: CGSize(width: self.dotsRadius * 2.0, height: self.dotsRadius * 2.0))
        layer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: self.dotsRadius).cgPath
        layer.fillColor = self.tintColor.cgColor
        layer.opacity = 0.0
        return layer
    }
    
    private func setupLayers() {
        for _ in 0..<self.dotsCount {
            let dotLayer = self.dotLayer()
            self.dotLayers.append(dotLayer)
            self.layer.addSublayer(dotLayer)
        }
    }
    
    private func animate(_ after: TimeInterval = 0) -> CAAnimationGroup {
        let opacityUp = CABasicAnimation(keyPath: "opacity")
        opacityUp.beginTime = after
        opacityUp.fromValue = 0.0
        opacityUp.toValue = self.dotsOpacity
        opacityUp.duration = 0.3
        
        
        let opacityDown = CABasicAnimation(keyPath: "opacity")
        opacityDown.beginTime = after + opacityUp.duration
        opacityDown.fromValue = self.dotsOpacity
        opacityDown.toValue = 0.0
        opacityDown.duration = 0.2
        
        let group = CAAnimationGroup()
        group.animations = [opacityUp, opacityDown]
        group.repeatCount = 4
        
        let time = CGFloat(self.dotsCount) * 0.2 + CGFloat(0.4)
        group.duration = CFTimeInterval(time)

        return group
    }
}
