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
        self.photoImageView.sd_setImage(with: URL(string: photo.sizes.last!.url))
        self.clipsToBounds = false
    }
}
