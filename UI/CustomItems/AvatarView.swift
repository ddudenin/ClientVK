//
//  AvatarView.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 03.02.2021.
//

import UIKit

@IBDesignable
final class AvatarView: UIView {
    
    @IBOutlet private var photoImageView: UIImageView! = UIImageView() {
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
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.shadowColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            let color = UIColor.rgba(r, g, b, alpha: a)
            
            self.layer.shadowColor = color.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowOpacity = 0.8
        }
    }
    
    func setImage(fromURL url: String) {
        self.photoImageView.setImage(at: url, placeholderImage: UIImage(systemName: "person.fill"))
    }
    
    func prepareForReuse() {
        self.photoImageView.image = nil
    }
}
