//
//  NewsFeedFooterTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 10.02.2021.
//

import UIKit

final class NewsFeedFooterTableViewCell: UITableViewCell {
    
    @IBOutlet private var commentsButton: UIButton!
    @IBOutlet private var sharesButton: UIButton!
    @IBOutlet var viewsButton: UIButton!
    @IBOutlet private var likeControl: LikeControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withPost post: PostData) {
        let like = post.item.likes
        self.likeControl.configure(withLikesCount: like.count, state: like.userLikes == 1)
        self.commentsButton.setTitle(convertCountToString(count: post.item.comments.count), for: .normal)
        self.sharesButton.setTitle(convertCountToString(count: post.item.reposts.count), for: .normal)
        self.viewsButton.setTitle(convertCountToString(count: post.item.views.count), for: .normal)
    }
}
