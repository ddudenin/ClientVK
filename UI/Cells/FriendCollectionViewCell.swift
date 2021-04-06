//
//  FriendCollectionViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import SDWebImage

class FriendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var likeControl: LikeControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(withPhoto photo: PhotoItem) {
        self.photoImageView.sd_setImage(with: URL(string: photo.sizes.last!.url))
        self.likeControl.configure(withLikes: photo.likes!)
    }
}
