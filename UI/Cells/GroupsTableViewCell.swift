//
//  GroupsTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 30.01.2021.
//

import UIKit

final class GroupsTableViewCell: UITableViewCell {
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.nameLabel.text = nil
        self.photoImageView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withGroup group: GroupDisplayItem) {
        self.nameLabel.text = group.name
        self.photoImageView.setImage(at: group.avatarURL, placeholderImage: UIImage(systemName: "person.2.fill"))
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
