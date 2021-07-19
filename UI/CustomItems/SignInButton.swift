//
//  SignInButton.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 11.04.2021.

import UIKit

@IBDesignable
class SignInButton: UIButton {
    
    @IBInspectable var bgColor: UIColor = UIColor.lightGray {
        didSet {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.bgColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            let color = UIColor.rgba(r, g, b, alpha: a)
            
            self.backgroundColor = color
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.lightGray {
        didSet {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.borderColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            let color = UIColor.rgba(r, g, b, alpha: a)
            
            self.layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable var textColor: UIColor = UIColor.lightGray {
        didSet {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.textColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            let color = UIColor.rgba(r, g, b, alpha: a)
            
            self.setTitleColor(color, for: .normal)
        }
    }
    
    @IBInspectable var text: String = "Sign in" {
        didSet {
            self.setTitle(self.text, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupButton()
    }
    
    private func setupButton() {
        self.layer.cornerRadius = 20.0
        self.layer.borderWidth = 0.0
        self.titleLabel?.font = UIFont.systemFont15Bold
        self.setImage(UIImage(systemName: "chevron.forward.circle"), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
    }
}
