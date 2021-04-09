//
//  FriendPhotoCollectionViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/21/21.
//

import UIKit
import SDWebImage

class FriendPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(withPhoto photo: Photo) {
        self.photoImageView.sd_setImage(with: URL(string: photo.sizes.last!.url))
        self.clipsToBounds = false
    }
}
