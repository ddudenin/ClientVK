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
              let sizesDict = value["sizes"] as? [Any],
              let text = value["text"] as? String,
              let likesDict = value["likes"] as? [String: Any],
              let userLikes = likesDict["user_likes"] as? Int,
              let likesCount = likesDict["count"] as? Int,
              let repostsDict = value["reposts"] as? [String: Any],
              let repostsCount = repostsDict["count"] as? Int
        else { return nil }
        
        self.albumID = albumID
        self.date = date
        self.id = id
        self.ownerID = ownerID
        self.hasTags = hasTags
        self.postID = postID
        self.text = text
        self.likes = Likes(userLikes: userLikes, count: likesCount)
        self.reposts = Reposts(count: repostsCount)
        
        self.sizes = []
        for item in sizesDict {
            guard let curDict = item as? [String: Any],
                  let height = curDict["height"] as? Int,
                  let url = curDict["url"] as? String,
                  let type = curDict["type"] as? String,
                  let width = curDict["width"] as? Int
            else { return nil }
            
            self.sizes.append(Size(height: height, url: url, type: type, width: width))
        }
        
        self.ref = snapshot.ref
    }
    
    init?(dict: [String: Any]) {
        guard let albumID = dict["album_id"] as? Int,
              let date = dict["date"] as? Int,
              let id = dict["id"] as? Int,
              let ownerID = dict["owner_id"] as? Int,
              let hasTags = dict["has_tags"] as? Bool,
              let postID = dict["post_id"] as? Int?,
              let sizesDict = dict["sizes"] as? [String: Any],
              let text = dict["text"] as? String,
              let likeDict = dict["likes"] as? [String: Any],
              let userLikes = likeDict["user_likes"] as? Int,
              let likesCount = likeDict["count"] as? Int,
              let repostsDict = dict["reposts"] as? [String: Any],
              let repostsCount = repostsDict["count"] as? Int
        else { return nil }
        
        self.albumID = albumID
        self.date = date
        self.id = id
        self.ownerID = ownerID
        self.hasTags = hasTags
        self.postID = postID
        self.text = text
        self.likes = Likes(userLikes: userLikes, count: likesCount)
        self.reposts = Reposts(count: repostsCount)
        
        self.sizes = []
        for item in sizesDict {
            guard let curDict = item.value as? [String: Any],
                  let height = curDict["height"] as? Int,
                  let url = curDict["url"] as? String,
                  let type = curDict["type"] as? String,
                  let width = curDict["width"] as? Int
            else { return nil }
            
            self.sizes.append(Size(height: height, url: url, type: type, width: width))
        }
    }
    
    func toAnyObject() -> [String: Any] {
        [
            "album_id": albumID,
            "date": date,
            "id": id,
            "owner_id": ownerID,
            "has_tags": hasTags,
            "post_id": postID ?? -1,
            "sizes": getSizesDict(),
            "text": text,
            "likes": likes.toAnyObject(),
            "reposts": reposts.toAnyObject()
        ]
    }
    
    func getSizesDict() -> [String: [String: Any]] {
        var dict = [String: [String: Any]]()
        
        for (index, elem) in self.sizes.enumerated() {
            dict[String(index)] = elem.toAnyObject()
        }
        
        return dict
    }
    
}

class Likes: Codable {
    var userLikes: Int
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
    
    init(userLikes: Int, count: Int) {
        self.userLikes = userLikes
        self.count = count
    }
    
    func toAnyObject() -> [String: Any] {
        [
            "user_likes": userLikes,
            "count": count
        ]
    }
}

class Reposts: Codable {
    var count: Int
    
    init(count: Int) {
        self.count = count
    }
    
    func toAnyObject() -> [String: Any] {
        [
            "count": count
        ]
    }
}

class Size: Codable {
    var height: Int
    var url: String
    var type: String
    var width: Int
    
    init(height: Int, url: String, type: String, width: Int) {
        self.height = height
        self.url = url
        self.type = type
        self.width = width
    }
    
    func toAnyObject() -> [String: Any] {
        [
            "height": height,
            "url": url,
            "type": type,
            "width": width
        ]
    }
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
