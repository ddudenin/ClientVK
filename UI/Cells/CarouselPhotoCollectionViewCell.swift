//
//  CarouselPhotoCollectionViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/21/21.
//

import UIKit
import SDWebImage

final class CarouselPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(withPhoto photo: Photo) {
        guard let urlString = photo.sizes.last?.url else { return }
        self.photoImageView.sd_setImage(with: URL(string: urlString))
        self.clipsToBounds = false
    }
}
