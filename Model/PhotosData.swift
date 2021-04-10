//
//  PhotosData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 3/23/21.
//

import Foundation
import FirebaseDatabase

class PhotosJSONData: Codable {
    let response: PhotosResponse
}

class PhotosResponse: Codable {
    let count: Int
    let items: [Photo]
}

class Photo: Codable {
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
    
    var ref: DatabaseReference? = nil
    
    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case postID = "post_id"
        case sizes, text, likes, reposts
    }
    
    init(albumID: Int,
         date: Int,
         id: Int,
         ownerID: Int,
         hasTags: Bool,
         postID: Int?,
         sizes: [Size],
         text: String,
         likes: Likes,
         reposts: Reposts) {
        self.albumID = albumID
        self.date = date
        self.id = id
        self.ownerID = ownerID
        self.hasTags = hasTags
        self.postID = postID
        self.sizes = sizes
        self.text = text
        self.likes = likes
        self.reposts = reposts
        
        self.ref = nil
    }
    
    convenience init(from photoModel: Photo) {
        self.init(albumID: photoModel.albumID, date: photoModel.date, id: photoModel.id, ownerID: photoModel.ownerID, hasTags: photoModel.hasTags, postID: photoModel.postID, sizes: photoModel.sizes, text: photoModel.text, likes: photoModel.likes, reposts: photoModel.reposts)
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        
        guard let albumID = value["album_id"] as? Int,
              let date = value["date"] as? Int,
              let id = value["id"] as? Int,
              let ownerID = value["owner_id"] as? Int,
              let hasTags = value["has_tags"] as? Bool,
              let postID = value["post_id"] as? Int?,
              let sizes = value["sizes"] as? [Size],
              let text = value["text"] as? String,
              let likes = value["likes"] as? Likes,
              let reposts = value["reposts"] as? Reposts
        else { return nil }
        
        self.albumID = albumID
        self.date = date
        self.id = id
        self.ownerID = ownerID
        self.hasTags = hasTags
        self.postID = postID
        self.sizes = sizes
        self.text = text
        self.likes = likes
        self.reposts = reposts
        
        self.ref = snapshot.ref
    }
    
    init?(dict: [String: Any]) {
        guard let albumID = dict["album_id"] as? Int,
              let date = dict["date"] as? Int,
              let id = dict["id"] as? Int,
              let ownerID = dict["owner_id"] as? Int,
              let hasTags = dict["has_tags"] as? Bool,
              let postID = dict["post_id"] as? Int?,
              let sizes = dict["sizes"] as? [Size],
              let text = dict["text"] as? String,
              let likes = dict["likes"] as? Likes,
              let reposts = dict["reposts"] as? Reposts
        else { return nil }
        
        self.albumID = albumID
        self.date = date
        self.id = id
        self.ownerID = ownerID
        self.hasTags = hasTags
        self.postID = postID
        self.sizes = sizes
        self.text = text
        self.likes = likes
        self.reposts = reposts
    }
        
        func toAnyObject() -> [String: Any] {
            [
                "album_id": albumID,
                "date": date,
                "id": id,
                "owner_id": ownerID,
                "has_tags": hasTags,
                "post_id": postID ?? -1,
                "sizes": sizes,
                "text": text,
                "likes": likes,
                "reposts": reposts
            ]
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
    var height: Int
    var url: String
    var type: String
    var width: Int
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
