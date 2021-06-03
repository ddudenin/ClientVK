//
//  NewsFeedSingleImageTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 03.06.2021.
//

import UIKit

class NewsFeedSingleImageTableViewCell: UITableViewCell {

    @IBOutlet weak var singleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withPost post: PostData) {
        self.singleImageView.setImage(at: post.photos[0].url, placeholderImage: UIImage(systemName: "newspaper.fill"))
    }
    
}
