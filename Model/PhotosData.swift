//
//  PhotosData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 23.03.2021.
//

import Foundation
import RealmSwift

struct PhotosJSONData: Codable {
    let response: PhotosResponse
}

struct PhotosResponse: Codable {
    let count: Int
    let items: [Photo]
}

class Photo: Object, Codable {
    @objc dynamic var albumID: Int = -1
    @objc dynamic var date: Int = 0
    @objc dynamic var id: Int = -1
    @objc dynamic var ownerID: Int = -1
    @objc dynamic var hasTags: Bool = false
    var postID: Int?
    var sizes = List<Size>()
    @objc dynamic var text: String = ""
    @objc dynamic var likes: Likes?
    @objc dynamic var reposts: Reposts?
    
    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case postID = "post_id"
        case sizes, text, likes, reposts
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Likes: Object, Codable {
    @objc dynamic var userLikes: Int = 0
    @objc dynamic var count: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

class Reposts: Object, Codable {
    @objc dynamic var count: Int = 0
}

class Size: Object, Codable {
    @objc dynamic var height: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var width: Int = 0
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
