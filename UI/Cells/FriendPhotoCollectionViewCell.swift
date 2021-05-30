//
//  FriendPhotoCollectionViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 30.01.2021.
//

import UIKit

final class FriendPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var likeControl: LikeControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.photoImageView.image = nil
        self.likeControl.prepareForReuse()
    }
    
    func configure(withPhoto photo: Photo, handler handle: ((Bool, Int) -> Void)? = nil) {
        if let likeInfo = photo.likes {
            self.likeControl.configure(withLikes: likeInfo, handler: handle)
        } else {
            self.likeControl.configure(withLikesCount: 0, state: false)
        }
        
        guard let urlString = photo.sizes.last?.url else { return }
        self.photoImageView.setImage(at: urlString, placeholderImage: UIImage(systemName: "photo.fill"))
    }
}
