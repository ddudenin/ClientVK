//
//  CommunitiesTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import SDWebImage

class CommunitiesTableViewCell: UITableViewCell {
    
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withGroup group: Group) {
        self.fullNameLabel.text = group.name
        self.photoImageView.sd_setImage(with: URL(string: group.photo50))
    }
}
