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
    
    func configure(withPhoto photo: Photo) {
        guard let urlString = photo.sizes.last?.url else { return }
        self.photoImageView.setImage(at: urlString, placeholderImage: UIImage(systemName: "photo.fill"))
        self.clipsToBounds = false
    }
}
