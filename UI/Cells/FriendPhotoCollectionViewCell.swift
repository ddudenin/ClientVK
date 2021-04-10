//
//  FriendPhotoCollectionViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import SDWebImage

final class FriendPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var likeControl: LikeControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(withPhoto photo: Photo, handler handle: ((Bool, Int) -> Void)? = nil) {
        self.photoImageView.sd_setImage(with: URL(string: photo.sizes.last!.url))
        
        self.likeControl.configure(withLikes: photo.likes, handler: handle)
    }
}
