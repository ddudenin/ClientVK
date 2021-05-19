//
//  NewsFeedAuthorTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/10/21.
//

import UIKit
import SDWebImage

final class NewsFeedAuthorTableViewCell: UITableViewCell {
    
    @IBOutlet private var createdByLabel: UILabel!
    @IBOutlet private var timeAgoLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView! {
        didSet {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withPost post: Article) {
        self.createdByLabel.text = post.source.name
        self.timeAgoLabel.text = utcToTimeAgoDisplay(dateString: post.publishedAt)
        self.profileImageView.sd_setImage(with: URL(string: "https://picsum.photos/id/\(Int.random(in: 0...1050))/200"))
    }
}
