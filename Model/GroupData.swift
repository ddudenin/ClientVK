//
//  GroupData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import Foundation
import UIKit

class Group {
    let name: String
    let avatar: UIImage?
    
    init(name: String, avatar: UIImage?) {
        self.name = name
        self.avatar = avatar
    }
}
