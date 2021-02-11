//
//  NewsTableViewCell.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/10/21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet var authorImageView: UIImageView!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var newsTextLabel: UILabel!
    @IBOutlet var newsPhotoImageView: UIImageView!
    @IBOutlet var viewsCountLabel: UILabel!
    @IBOutlet var commentsCountLabel: UILabel!
    @IBOutlet var repostsCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
