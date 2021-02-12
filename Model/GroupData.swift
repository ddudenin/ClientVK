//
//  GroupData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import Foundation

struct Group {
    let name: String
    let avatarName: String
    
    init(name: String, avatarName: String) {
        self.name = name
        self.avatarName = avatarName
    }
}


var groups: [Group] = [
    Group(name: "Быстрые займы за 5 минут", avatarName: "bitcoinsign.circle.fill"),
    Group(name: "Дворец Путина", avatarName: "crown.fill"),
    Group(name: "Психология успешных людей", avatarName: "star.fill"),
    Group(name: "Барахолка", avatarName: "giftcard.fill")
]

var groupsGlobal: [Group] = [
    Group(name: "American democracy: lie or reality", avatarName: "flag.fill"),
    Group(name: "Одноклассники", avatarName: "bubble.middle.bottom.fill"),
]
