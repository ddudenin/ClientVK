//
//  LikeControl.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/4/21.
//

import UIKit

@IBDesignable class LikeControl: UIControl {

    var count: Int = 0
    
    let selectColor: UIColor = UIColor.black
    let deselectedColor: UIColor = UIColor.lightGray
    
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
        button.setTitleColor(.lightGray, for: .normal)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.addTarget(self, action: #selector(handleLikeAvatar(_:)), for: .touchUpInside)
        
        let btnState = Bool.random()
        
        if btnState {
            button.isSelected = btnState
            count = Int.random(in: 1...100)
            label.textColor = selectColor
        } else {
            label.textColor = deselectedColor
        }

        label.text = "\(self.count)"

        stackView = UIStackView(arrangedSubviews: [self.button, self.label])
        
        self.addSubview(stackView)
        
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .center
    }
    
    @objc private func handleLikeAvatar(_ sender: UIButton) {
        let newState = !self.button.isSelected
        self.button.isSelected = newState
    
        count += newState ? 1 : -1
 
        label.text = "\(self.count)"
        label.textColor = newState && count > 0 ? selectColor : deselectedColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
}
