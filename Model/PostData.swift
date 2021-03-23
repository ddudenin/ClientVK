//
//  NewsData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/11/21.
//

import Foundation

struct Post {
    let createdBy: FriendItem
    let caption: String
    let imagesNames: [String]
    var likesCount: UInt
    var commentsCount: UInt
    var sharesCount: UInt
    var viewsCount: UInt
    
    init(user: FriendItem, caption: String) {
        self.createdBy = user
        self.caption = caption
        self.imagesNames = Array(repeating: user.photo200_Orig, count: Int.random(in: 1...10))
        
        self.likesCount = UInt.random(in: 0...1000000)
        self.commentsCount = UInt.random(in: 0...1000000)
        self.sharesCount = UInt.random(in: 0...100000)
        self.viewsCount = UInt.random(in: 0...1000000)
    }
}

var postsData = [
    Post(user: friendsArray.randomElement()!, caption: "Data Privacy Day at Apple: Improving transparency and empowering users. Data tracking is more widespread than ever. Learn how Apple’s privacy features help users take control over their data"),
    Post(user: friendsArray.randomElement()!, caption: "Apple Reports First Quarter Results. Revenue up 21 percent and EPS up 35 percent to new all-time records. iPhone, Wearables, and Services set new revenue records"),
    Post(user: friendsArray.randomElement()!, caption: "Dan Riccio begins a new chapter at Apple. John Ternus will join the executive team as senior vice president of Hardware Engineering"),
    Post(user: friendsArray.randomElement()!, caption: "Time to Walk: An inspiring audio walking experience comes to Apple Fitness+. Episodes feature personal stories, photos, and music from influential people to inspire Apple Watch users to walk more"),
    Post(user: friendsArray.randomElement()!, caption: "Apple launches major new Racial Equity and Justice Initiative projects to challenge systemic racism, advance racial equity nationwide. Commitments build on Apple’s $100 million pledge and include a first-of-its-kind education hub for HBCUs and an Apple Developer Academy in Detroit"),
    Post(user: friendsArray.randomElement()!, caption: "Monica Lozano joins Apple’s board of directors")
]

func convertCountToString(count number: UInt) -> String {
    let unitAbbreviations = ["K", "M", "B"]
    
    var value = Float(number)
    var index = -1
    
    while value >= 1000 {
        value /= 1000
        index += 1
    }
    
    guard index != -1 else { return "\(number)" }
    
    return  String(format: "%.1f", value) + unitAbbreviations[index]
}
