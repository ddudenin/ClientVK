//
//  FriendCollectionViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var likeControl: LikeControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(withPhoto photo: PhotoItem) {
        guard let imgURL = URL(string: photo.sizes[0].url) else { return }
        guard let imgData = try? Data(contentsOf: imgURL) else { return }
        self.photoImageView.image = UIImage(data: imgData)
        self.likeControl.configure(withLikes: photo.likes)
    }
}
