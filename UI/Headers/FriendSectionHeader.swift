//
//  FriendSectionHeader.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 10.02.2021.
//

import UIKit

final class FriendSectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet private var sectionNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.sectionNameLabel.text = nil
    }
    
    func configure(withName name: String) {
        self.sectionNameLabel.text = name
    }
}
