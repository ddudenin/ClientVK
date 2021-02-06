//
//  LikeControl.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/4/21.
//

import UIKit

@IBDesignable class LikeControl: UIControl {
    
    var count: Int = 0
    
    private let selectColor: UIColor = UIColor.black
    private let deselectedColor: UIColor = UIColor.lightGray
    
    private var button : UIButton = UIButton(type: .system)
    private var stackView: UIStackView!
    private var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.button.setTitleColor(.lightGray, for: .normal)
        self.button.setImage(UIImage(systemName: "heart"), for: .normal)
        self.button.setTitleColor(.white, for: .selected)
        self.button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        self.button.addTarget(self, action: #selector(handleLikePhoto(_:)), for: .touchUpInside)
        
        let btnState = Bool.random()
        
        if btnState {
            self.button.isSelected = btnState
            self.count = Int.random(in: 1...100)
            self.label.textColor = self.selectColor
        } else {
            self.label.textColor = self.deselectedColor
        }
        
        self.label.text = "\(self.count)"
        
        self.stackView = UIStackView(arrangedSubviews: [self.button, self.label])
        
        self.addSubview(stackView)
        
        self.stackView.spacing = 10
        self.stackView.axis = .horizontal
        self.stackView.alignment = .center
        self.stackView.distribution = .fillEqually
    }
    
    @objc private func handleLikePhoto(_ sender: UIButton) {
        let newState = !self.button.isSelected
        self.button.isSelected = newState
        
        count += newState ? 1 : -1
        
        self.label.text = "\(self.count)"
        self.label.textColor = newState && count > 0 ? self.selectColor : self.deselectedColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stackView.frame = bounds
    }
}
