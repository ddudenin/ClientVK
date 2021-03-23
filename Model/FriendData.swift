//
//  FriendData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import Foundation

struct FriendsJSONData: Codable {
    let response: FriendsResponse
}

struct FriendsResponse: Codable {
    let count: Int
    let items: [FriendItem]
}

struct FriendItem: Codable {
    let firstName: String
    let id: Int
    let lastName: String
    let canAccessClosed, isClosed: Bool
    let photo200_Orig: String
    let trackCode: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
        case photo200_Orig = "photo_200_orig"
        case trackCode = "track_code"
    }
    
    func getFullName() -> String {
        return firstName + " " + lastName
    }
}

var friendsArray: [FriendItem] = []
