//
//  LikeControl.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/4/21.
//

import UIKit

class LikeControl: UIControl {
    
    var likeCount: UInt = 0
    
    private let selectColor: UIColor = UIColor.black
    private let deselectedColor: UIColor = UIColor.darkGray
    
    var likeButton : UIButton = UIButton(type: .custom)
    
    private var likeCountLabel: UILabel = UILabel()
    //private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.likeButton.setImage(UIImage(named: "heart_empty"), for: .normal)
        self.likeButton.setImage(UIImage(named: "heart_filled"), for: .selected)
        
        self.likeButton.addTarget(self, action: #selector(handleLikeTap(_:)), for: .touchUpInside)
        
        let btnState = Bool.random()
        
        if btnState {
            self.likeButton.isSelected = btnState
            self.likeCount = UInt.random(in: 1...1000000)
            self.likeCountLabel.textColor = self.selectColor
        } else {
            self.likeCountLabel.textColor = self.deselectedColor
        }
        
        self.likeCountLabel.text = convertCountToString(count: self.likeCount)
        self.likeCountLabel.font = self.likeCountLabel.font.withSize(12)
        
        self.addSubview(self.likeButton)
        self.addSubview(self.likeCountLabel)
        
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.likeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.likeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.likeButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.likeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.likeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.likeCountLabel.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant: 3).isActive = true
        self.likeCountLabel.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.likeCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
    }
    
    @objc private func handleLikeTap(_ sender: UIButton) {
        let newState = !self.likeButton.isSelected
        self.likeButton.isSelected = newState
        
        if newState {
            self.likeCount += 1
        } else {
            self.likeCount -= 1
        }
        
        self.likeCountLabel.text = convertCountToString(count: self.likeCount)
        self.likeCountLabel.textColor = newState && self.likeCount > 0 ? self.selectColor : self.deselectedColor
        
        self.animate()
    }
    
    private func animate() {
        let posY = (self.likeButton.isSelected ? -1 : 1) * self.frame.height / 2
        self.likeCountLabel.transform = CGAffineTransform(translationX: 0, y: posY)
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.likeCountLabel.transform = .identity
                       },
                       completion: nil)
    }
}
