//
//  PostData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/11/21.
//

import Foundation

struct NewsJSONData: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

struct Article: Codable {
    var source: Source
    var author: String?
    var title: String
    var articleDescription: String?
    var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

struct Source: Codable {
    var id: String?
    var name: String
}

