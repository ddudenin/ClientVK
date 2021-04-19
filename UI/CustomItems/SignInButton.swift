//
//  SignInButton.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 4/11/21.

import UIKit

@IBDesignable
class SignInButton: UIButton {
    
    @IBInspectable var bgColor: UIColor = UIColor.lightGray {
        didSet {
            self.backgroundColor = self.bgColor
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.lightGray {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var textColor: UIColor = UIColor.lightGray {
        didSet {
            self.setTitleColor(self.textColor, for: .normal)
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
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.setImage(UIImage(systemName: "chevron.forward.circle"), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
    }
}
