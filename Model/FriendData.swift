//
//  FriendData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 30.01.2021.
//

import Foundation
import RealmSwift

struct FriendsJSONData: Codable {
    let response: FriendsResponse
}

struct FriendsResponse: Codable {
    let count: Int
    let items: [User]
}

class User: Object, Codable {
    @objc dynamic var firstName: String = ""
    @objc dynamic var id: Int = -1
    @objc dynamic var lastName: String = ""
    @objc dynamic var canAccessClosed: Bool = false
    @objc dynamic var photo200_Orig: String = ""
    @objc dynamic var trackCode: String = ""
    
    var fullName: String  {
        return firstName + " " + lastName
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
