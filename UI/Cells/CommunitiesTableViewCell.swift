//
//  CommunitiesTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit

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
    
    func configure(withGroup group: GroupItem) {
        self.fullNameLabel.text = group.name
        
        guard let imgURL = URL(string: group.photo50) else { return }
        guard let imgData = try? Data(contentsOf: imgURL) else { return }
        self.photoImageView.image = UIImage(data: imgData)
    }
}
