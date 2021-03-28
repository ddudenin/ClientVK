//
//  PhotosData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 3/23/21.
//

import Foundation

class PhotosJSONData: Codable {
    let response: PhotosResponse
}

class PhotosResponse: Codable {
    let count: Int
    let items: [PhotoItem]
}

class PhotoItem: Codable {
    var albumID: Int
    var date: Int
    var id: Int
    var ownerID: Int
    var hasTags: Bool
    var postID: Int?
    var sizes: [Size]
    var text: String
    var likes: Likes
    var reposts: Reposts
    
    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case postID = "post_id"
        case sizes, text, likes, reposts
    }
}

class Likes: Codable {
    var userLikes: Int
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

class Reposts: Codable {
    var count: Int
}

class Size: Codable {
    let height: Int
    let url: String
    let type: String
    let width: Int
}

enum TypeEnum: String, Codable {
    case m = "m"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
}
