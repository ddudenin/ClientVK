//
//  NewsData.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/11/21.
//

import Foundation

struct News {
    let authorName: String
    let authorImageName: String
    let newsText: String
    let newsImagesNames: [String]
    var likeCount: UInt
    var commentsCount: UInt
    var repostCount: UInt
    var viewsCount: UInt
    
    init(authorName: String, authorImageName: String, newsText: String, newsImagesNames: [String]) {
        self.authorName = authorName
        self.authorImageName = authorImageName
        self.newsText = newsText
        self.newsImagesNames = newsImagesNames
        
        self.likeCount = UInt.random(in: 0...100)
        self.commentsCount = UInt.random(in: 0...100)
        self.repostCount = UInt.random(in: 0...100)
        self.viewsCount = UInt.random(in: 0...1000000)
    }
}
