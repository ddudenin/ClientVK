//
//  CarouselPhotoCollectionViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 21.02.2021.
//

import UIKit

final class CarouselPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.photoImageView.image = nil
    }
    
    func configure(withPhoto photo: PhotoDisplayItem) {
        self.photoImageView.setImage(at: photo.photoURL, placeholderImage: UIImage(systemName: "photo.fill"))
        self.clipsToBounds = false
    }
}
