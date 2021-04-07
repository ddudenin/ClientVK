//
//  FriendPhotoCollectionViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/21/21.
//

import UIKit

class FriendPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(withPhoto photo: PhotoItem) {
        self.photoImageView.image = GetImage(fromURL: photo.sizes.last!.url)
        self.clipsToBounds = false
    }
}
