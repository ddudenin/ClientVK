//
//  PostData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 11.02.2021.
//

import Foundation

class PostJSONData: Codable {
    let response: PostResponse
}

class PostResponse: Codable {
    let items: [Post]
    let profiles: [Profile]
    let groups: [Group]
    let nextFrom: String
    
    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

class Post: Codable {
    let sourceID: Int
    let date: Int
    let text: String
    let attachments: [Attachment]?
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let views: Views
    
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date, text, attachments, comments, likes, reposts, views
    }
}

class Comments: Codable {
    let count: Int
}

class Views: Codable {
    let count: Int
}

class Attachment: Codable {
    let type: String
    let photo: Photo?
}

class Profile: Codable {
    let firstName: String
    let id: Int
    let lastName: String
    let canAccessClosed, isClosed: Bool?
    let sex: Int
    let screenName: String?
    let photo50, photo100: String
    let online: Int
    let onlineMobile, onlineApp: Int?
    let deactivated: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
        case sex
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case online
        case onlineMobile = "online_mobile"
        case onlineApp = "online_app"
        case deactivated
    }
    
    var fullName: String  {
        return firstName + " " + lastName
    }
}


struct Author {
    var name: String = ""
    var avatarURL: String = ""
}

struct PostData {
    var item: Post
    var author: Author
    var photos: [String]
}


