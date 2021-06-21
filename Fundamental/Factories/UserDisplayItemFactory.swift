//
//  UserDisplayItemFactory.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 21.06.2021.
//

import UIKit

enum UserDisplayItemFactory {
    static func make(for user: RLMUser) -> UserDisplayItem {
        let fullName = user.fullName
        let avatarURL = user.photo200Orig
        
        return UserDisplayItem(fullName: fullName, avatarURL: avatarURL)
    }
}
