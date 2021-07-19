//
//  GroupDisplayItemFactory.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 21.06.2021.
//

import UIKit

enum GroupDisplayItemFactory {
    static func make(for group: GroupDTO) -> GroupDisplayItem {
        let name = group.name
        let avatarURL = group.photo200
        
        return GroupDisplayItem(name: name, avatarURL: avatarURL)
    }
    
    static func make(for group: RLMGroup) -> GroupDisplayItem {
        let name = group.name
        let avatarURL = group.photo200
        
        return GroupDisplayItem(name: name, avatarURL: avatarURL)
    }
}
