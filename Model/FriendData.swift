//
//  FriendData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import Foundation
import UIKit

struct Friend {
    let name: String
    let surname: String
    
    let photoName: String
    
    init(name: String, surname: String, photoName: String) {
        self.name = name
        self.surname = surname
        self.photoName = photoName
    }
    
    func getFullName() -> String {
        return name + " " + surname
    }
}
