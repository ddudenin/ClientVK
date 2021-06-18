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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.createdByLabel.text = nil
        self.timeAgoLabel.text = nil
        self.profileImageView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withPost post: PostData, timeAgo date: String) {
        self.createdByLabel.text = post.source.title
        self.timeAgoLabel.text = date
        self.profileImageView.setImage(at: post.source.imageUrl, placeholderImage: UIImage(systemName: "person.fill"))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
    }
}
