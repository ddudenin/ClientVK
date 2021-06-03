//
//  DesignableUITextField.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 11.04.2021.
//

import UIKit

@IBDesignable
class TextFieldWithImage: UITextField {
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += self.leftPadding
        return textRect
    }
    
    func updateView() {
        if let image = leftImage {
            self.leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            self.leftView = imageView
        } else {
            self.leftViewMode = UITextField.ViewMode.never
            self.leftView = nil
        }
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}
