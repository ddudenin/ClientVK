//
//  AvatarView.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/3/21.
//

import UIKit

@IBDesignable
class AvatarView: UIView {
    
    @IBOutlet var photoImageView: UIImageView! = UIImageView() {
        didSet {
            photoImageView.layer.masksToBounds = true
            photoImageView.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .cyan {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowOpacity = 0.8
        }
    }
}
