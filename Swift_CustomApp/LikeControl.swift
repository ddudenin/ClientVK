//
//  LikeControl.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/4/21.
//

import UIKit

class LikeControl: UIControl {
    
    var likeCount: Int = 0
    
    private let selectColor: UIColor = UIColor.black
    private let deselectedColor: UIColor = UIColor.lightGray
    
    private var likeButton : UIButton = UIButton(type: .system)
    private var likeCountLabel: UILabel = UILabel()
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
  
        //self.likeButton.setImage(UIImage(named: "heart_empty"), for: .normal)
        //self.likeButton.setImage(UIImage(named: "heart_filled"), for: .selected)
        
        self.likeButton.addTarget(self, action: #selector(handleLikePhoto(_:)), for: .touchUpInside)
        
        let btnState = Bool.random()
        
        if btnState {
            self.likeButton.isSelected = btnState
            self.likeCount = Int.random(in: 1...100)
            self.likeCountLabel.textColor = self.selectColor
        } else {
            self.likeCountLabel.textColor = self.deselectedColor
        }
        
        self.likeCountLabel.text = "\(self.likeCount)"
        
        self.stackView = UIStackView(arrangedSubviews: [self.likeButton, self.likeCountLabel])
        
        self.addSubview(stackView)
        
        self.stackView.spacing = 10
        self.stackView.axis = .horizontal
        self.stackView.alignment = .center
        self.stackView.distribution = .fillEqually
    }
    
    @objc private func handleLikePhoto(_ sender: UIButton) {
        let newState = !self.likeButton.isSelected
        self.likeButton.isSelected = newState
        
        self.likeCount += newState ? 1 : -1
        
        self.likeCountLabel.text = "\(self.likeCount)"
        self.likeCountLabel.textColor = newState && self.likeCount > 0 ? self.selectColor : self.deselectedColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stackView.frame = bounds
    }
}
