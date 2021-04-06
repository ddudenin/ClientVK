//
//  FriendsTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import SDWebImage

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var photoView: AvatarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withFriend friend: FriendItem) {
        self.fullNameLabel.text = friend.getFullName()
        self.photoView.photoImageView.sd_setImage(with: URL(string: friend.photo200_Orig))
    }
}
