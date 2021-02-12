//
//  PostTableViewCell.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/10/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet var createdByLabel: UILabel!
    @IBOutlet var timeAgoLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var commentsButton: UIButton!
    @IBOutlet var sharesButton: UIButton!
    @IBOutlet var viewsCountLabel: UILabel!
    @IBOutlet var likesButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
