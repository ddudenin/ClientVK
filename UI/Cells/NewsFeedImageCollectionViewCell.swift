//
//  NewsFeedImageCollectionViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/13/21.
//

import UIKit
import SDWebImage

final class NewsFeedImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var imageView: UIImageView! {
        didSet {
            self.imageView.contentMode = .scaleAspectFill
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configure(withStringURL url: String) {
        self.imageView.sd_setImage(with: URL(string: url))
    }
}
