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
    
    func configure(withPhoto photo: PhotoDisplayItem, handler handle: ((Bool, Int) -> Void)? = nil) {
        self.likeControl.configure(withLikes: photo.likes, handler: handle)    
        self.photoImageView.setImage(at: photo.photoURL, placeholderImage: UIImage(systemName: "photo.fill"))
    }
}
