//
//  GroupsTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import SDWebImage

final class GroupsTableViewCell: UITableViewCell {
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withGroup group: Group) {
        self.nameLabel.text = group.name
        self.photoImageView.sd_setImage(with: URL(string: group.photo50))
    }
    
    func animate() {
        self.photoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(4.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.photoImageView.transform = CGAffineTransform.identity
                       },
                       completion: nil
        )
    }
}
