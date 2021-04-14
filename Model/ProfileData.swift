//
//  ProfileData.swift
//  Swift_CustomApp
//
//  Created by user192247 on 4/14/21.
//

import Foundation

struct ProfileJSONData: Codable {
    var response: Profile
}

struct Profile: Codable {
    var id: Int
    var firstName: String
    var lastName: String
    var maidenName: String?
    var screenName: String?
    var sex: Int
    var relation: Int
    var relationPartner: User?
    var relationPending: Int?
    var relationRequests: [User]?
    var bdate: String
    var bdateVisibility: Int
    var homeTown: String
    var country: Country?
    var city: City?
    var nameRequest: Request?
    var status: String
    var phone: String


    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case maidenName = "maiden_name"
        case screenName = "screen_name"
        case sex
        case relation
        case relationPartner = "relation_partner"
        case relationPending = "relation_pending"
        case relationRequests = "relation_requests"
        case bdate
        case bdateVisibility = "bdate_visibility"
        case homeTown = "home_town"
        case country, city, status, phone
    }
    
    var fullName: String {
        return firstName + " " + lastName
    }
}

struct Country: Codable {
    var id: Int
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
    }
}

struct City: Codable {
    var id: Int
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
    }
}

struct Request: Codable {
    var id: Int
    var status: String
    var firstName: String
    var lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
