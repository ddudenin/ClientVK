//
//  FriendData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import Foundation
import UIKit

class Friend {
    let fullName: String
    let photo: UIImage?
    
    init(fullName: String, photo: UIImage?) {
        self.fullName = fullName
        self.photo = photo
    }
}
