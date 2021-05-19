//
//  NewsFeedTextTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/10/21.
//

import UIKit

final class NewsFeedTextTableViewCell: UITableViewCell {
    
    @IBOutlet private var captionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withPost post: Article) {
        if let caption = post.articleDescription,
           !caption.isEmpty {
            self.captionLabel.text = caption
        } else {
            self.captionLabel.text = post.title
        }
    }
}
