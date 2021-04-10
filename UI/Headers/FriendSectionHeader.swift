//
//  FriendSectionHeader.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/10/21.
//

import UIKit

final class FriendSectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet var sectionNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(withName name: String) {
        self.sectionNameLabel.text = name
    }
}
