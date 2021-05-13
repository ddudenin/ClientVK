//
//  NewsFeedFooterTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/10/21.
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
    
    func configure(withPost post: Article) {
        self.likeControl.configure(withLikesCount: Int.random(in: 0...1000000), state: Bool.random())
        self.commentsButton.setTitle(convertCountToString(count: Int.random(in: 0...1000000)), for: .normal)
        self.sharesButton.setTitle(convertCountToString(count: Int.random(in: 0...10000000)), for: .normal)
        self.viewsButton.setTitle(convertCountToString(count: Int.random(in: 0...10000000)), for: .normal)
    }
}
