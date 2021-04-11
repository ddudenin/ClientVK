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
            updateView()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var textColor: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var text: String = "Sign in" {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = 20.0
        self.layer.borderWidth = 1.0
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.setImage(UIImage(systemName: "chevron.forward.circle"), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
    }
    
    private func updateView() {
        self.backgroundColor = self.bgColor
        self.layer.borderColor = self.borderColor.cgColor
        self.setTitle(self.text, for: .normal)
        self.setTitleColor(self.textColor, for: .normal)
    }
}
