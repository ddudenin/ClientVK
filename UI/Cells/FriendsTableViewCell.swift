//
//  FriendsTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit

final class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet private var fullNameLabel: UILabel!
    @IBOutlet private var avatarView: AvatarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withUser user: User) {
        self.fullNameLabel.text = user.getFullName()
        self.avatarView.setImage(fromURL: user.photo200_Orig)
    }
}
