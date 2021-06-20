//
//  PostData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 11.02.2021.
//

import Foundation
import UIKit

struct PostRequestData: Codable {
    let response: PostResponse
}

struct PostResponse: Codable {
    let items: [Post]
    let profiles: [Profile]
    let groups: [Group]
    let nextFrom: String?
}

struct Post: Codable {
    let sourceId: Int
    let date: Int
    let text: String
    let attachments: [Attachment]?
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let views: Views
}

struct Comments: Codable {
    let count: Int
}

struct Views: Codable {
    let count: Int
}

struct Attachment: Codable {
    let type: String
    let photo: Photo?
}

struct Profile: Codable, NewsSource {
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
    
    var title: String { return "\(firstName) \(lastName)" }
    var imageUrl: String { return photo100 }
}

struct PostData {
    var source: NewsSource
    var item: Post
    var photos: [Size]
}


