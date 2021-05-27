//
//  NewsFeedImageCollectionViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 13.02.2021.
//

import UIKit

final class NewsFeedImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var imageView: UIImageView! {
        didSet {
            self.imageView.contentMode = .scaleAspectFit
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configure(withStringURL url: String) {
        self.imageView.setImage(at: url, placeholderImage: UIImage(systemName: "newspaper.fill"))
    }
}
