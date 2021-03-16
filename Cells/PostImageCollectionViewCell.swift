//
//  PostImageCollectionViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/13/21.
//

import UIKit

class PostImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView! {
        didSet {
            self.imageView.contentMode = .scaleAspectFill
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
}
