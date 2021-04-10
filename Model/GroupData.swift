//
//  GroupData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import Foundation
import FirebaseDatabase

class GroupsJSONData: Codable {
    let response: GroupsResponse
}

class GroupsResponse: Codable {
    let count: Int
    let items: [Group]
}

class Group: Codable {
    var id: Int
    var name: String
    var screenName: String
    var isClosed: Int
    var type: String
    var isAdmin: Int
    var isMember: Int
    var isAdvertiser: Int
    var photo50: String
    var photo100: String
    var photo200: String
    
    var ref: DatabaseReference? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
    
    init(id: Int, name: String,
         screenName: String,
         isClosed: Int,
         type: String,
         isAdmin: Int,
         isMember: Int,
         isAdvertiser: Int,
         photo50: String,
         photo100: String,
         photo200: String) {
        self.id = id
        self.name = name
        self.screenName = screenName
        self.isClosed = isClosed
        self.type = type
        self.isAdmin = isAdmin
        self.isMember = isMember
        self.isAdvertiser = isAdvertiser
        self.photo50 = photo50
        self.photo100 = photo100
        self.photo200 = photo200
        
        self.ref = nil
    }
    
    convenience init(from groupModel: Group) {
        self.init(id: groupModel.id, name: groupModel.name, screenName: groupModel.screenName, isClosed: groupModel.isClosed, type: groupModel.type, isAdmin: groupModel.isAdmin, isMember: groupModel.isMember, isAdvertiser: groupModel.isAdvertiser, photo50: groupModel.photo50, photo100: groupModel.photo100, photo200: groupModel.photo200)
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        
        guard let id = value["id"] as? Int,
              let name = value["name"] as? String,
              let screenName = value["screen_name"] as? String,
              let isClosed = value["is_closed"] as? Int,
              let type = value["type"] as? String,
              let isAdmin = value["is_admin"] as? Int,
              let isMember = value["is_member"] as? Int,
              let isAdvertiser = value["is_advertiser"] as? Int,
              let photo50 = value["photo_50"] as? String,
              let photo100 = value["photo_100"] as? String,
              let photo200 = value["photo_200"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.screenName = screenName
        self.isClosed = isClosed
        self.type = type
        self.isAdmin = isAdmin
        self.isMember = isMember
        self.isAdvertiser = isAdvertiser
        self.photo50 = photo50
        self.photo100 = photo100
        self.photo200 = photo200
        
        self.ref = snapshot.ref
    }
    
    init?(dict: [String: Any]) {
        guard let id = dict["id"] as? Int,
              let name = dict["name"] as? String,
              let screenName = dict["screen_name"] as? String,
              let isClosed = dict["is_closed"] as? Int,
              let type = dict["type"] as? String,
              let isAdmin = dict["is_admin"] as? Int,
              let isMember = dict["is_member"] as? Int,
              let isAdvertiser = dict["is_advertiser"] as? Int,
              let photo50 = dict["photo_50"] as? String,
              let photo100 = dict["photo_100"] as? String,
              let photo200 = dict["photo_200"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.screenName = screenName
        self.isClosed = isClosed
        self.type = type
        self.isAdmin = isAdmin
        self.isMember = isMember
        self.isAdvertiser = isAdvertiser
        self.photo50 = photo50
        self.photo100 = photo100
        self.photo200 = photo200
        
        self.ref = nil
    }
    
    func toAnyObject() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "screen_name": screenName,
            "is_closed": isClosed,
            "type": type,
            "is_admin": isAdmin,
            "is_member": isMember,
            "is_advertiser": isAdvertiser,
            "photo_50": photo50,
            "photo_100": photo100,
            "photo_200": photo200
        ]
    }
}
