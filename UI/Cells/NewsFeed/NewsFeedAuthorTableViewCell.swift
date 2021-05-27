//
//  NewsFeedAuthorTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 10.02.2021.
//

import UIKit

final class NewsFeedAuthorTableViewCell: UITableViewCell {
    
    @IBOutlet private var createdByLabel: UILabel!
    @IBOutlet private var timeAgoLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withPost post: PostData) {
        self.createdByLabel.text = post.author.name
        self.timeAgoLabel.text = utcToTimeAgoDisplay(date: Date(timeIntervalSince1970: TimeInterval(post.item.date)))
        self.profileImageView.setImage(at: post.author.avatarURL, placeholderImage: UIImage(systemName: "person.fill"))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
    }
}
