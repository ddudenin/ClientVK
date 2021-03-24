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
    let albumID, date, id, ownerID: Int
    let hasTags: Bool
    let postID: Int?
    let sizes: [Size]
    let text: String
    let likes: Likes
    let reposts: Reposts
    
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
    let userLikes, count: Int
    
    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

class Reposts: Codable {
    let count: Int
}

class Size: Codable {
    let height: Int
    let url: String
    let type: TypeEnum
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
