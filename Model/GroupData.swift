//
//  GroupData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 30.01.2021.
//

import Foundation
import RealmSwift

struct GroupsRequestData: Codable {
    let response: GroupsResponse
}

struct GroupsResponse: Codable {
    let count: Int
    let items: [Group]
}

class Group: Object, Codable, NewsSource {
    @objc dynamic var id: Int = -1
    @objc dynamic var name: String = ""
    @objc dynamic var screenName: String = ""
    @objc dynamic var isClosed: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var isAdmin: Int = 0
    @objc dynamic var isMember: Int = 0
    @objc dynamic var isAdvertiser: Int = 0
    @objc dynamic var photo50: String = ""
    @objc dynamic var photo100: String = ""
    @objc dynamic var photo200: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var title: String { return name }
    var imageUrl: String { return photo200 }
}
