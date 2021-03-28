//
//  GroupData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import Foundation
import RealmSwift

class GroupsJSONData: Codable {
    let response: GroupsResponse
}

class GroupsResponse: Codable {
    let count: Int
    let items: [GroupItem]
}

class GroupItem: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var name: String
    @objc dynamic var screenName: String
    @objc dynamic var isClosed: Int
    @objc dynamic var type: String
    @objc dynamic var isAdmin: Int
    @objc dynamic var isMember: Int
    @objc dynamic var isAdvertiser: Int
    @objc dynamic var photo50: String
    @objc dynamic var photo100: String
    @objc dynamic var photo200: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}

var groups: [GroupItem] = []
