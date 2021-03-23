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
        guard let imgURL = URL(string: photo.sizes.last!.url) else { return }
        guard let imgData = try? Data(contentsOf: imgURL) else { return }
        self.photoImageView.image = UIImage(data: imgData)
        self.clipsToBounds = false
    }
}
