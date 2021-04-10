//
//  FriendData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import Foundation
import FirebaseDatabase

class FriendsJSONData: Codable {
    let response: FriendsResponse
}

class FriendsResponse: Codable {
    let count: Int
    let items: [User]
}

class User: Codable {
    var firstName: String
    var id: Int
    var lastName: String
    var canAccessClosed: Bool
    var photo200_Orig: String
    var trackCode: String
    
    var ref: DatabaseReference? = nil
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case photo200_Orig = "photo_200_orig"
        case trackCode = "track_code"
    }
    
    func getFullName() -> String {
        return firstName + " " + lastName
    }
    
    init(firstName: String, id: Int, lastName: String, canAccessClosed: Bool, photo200_Orig: String, trackCode: String) {
        self.firstName = firstName
        self.id = id
        self.lastName = lastName
        self.canAccessClosed = canAccessClosed
        self.photo200_Orig = photo200_Orig
        self.trackCode = trackCode
        
        self.ref = nil
    }
    
    convenience init(from userModel: User) {
        self.init(firstName: userModel.firstName, id: userModel.id, lastName: userModel.lastName, canAccessClosed: userModel.canAccessClosed, photo200_Orig: userModel.photo200_Orig, trackCode: userModel.trackCode)
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        
        guard let firstName = value["first_name"] as? String,
              let id = value["id"] as? Int,
              let lastName = value["last_name"] as? String,
              let canAccessClosed = value["can_access_closed"] as? Bool,
              let photo200_Orig = value["photo_200_orig"] as? String,
              let trackCode = value["track_code"] as? String
        else { return nil }
        
        self.firstName = firstName
        self.id = id
        self.lastName = lastName
        self.canAccessClosed = canAccessClosed
        self.photo200_Orig = photo200_Orig
        self.trackCode = trackCode
        
        self.ref = snapshot.ref
    }
    
    init?(dict: [String: Any]) {
        guard let firstName = dict["first_name"] as? String,
              let id = dict["id"] as? Int,
              let lastName = dict["last_name"] as? String,
              let canAccessClosed = dict["can_access_closed"] as? Bool,
              let photo200_Orig = dict["photo_200_orig"] as? String,
              let trackCode = dict["track_code"] as? String else { return nil }
        
        self.firstName = firstName
        self.id = id
        self.lastName = lastName
        self.canAccessClosed = canAccessClosed
        self.photo200_Orig = photo200_Orig
        self.trackCode = trackCode
        
        self.ref = nil
    }
    
    func toAnyObject() -> [String: Any] {
        [
            "first_name": firstName,
            "id": id,
            "last_name": lastName,
            "can_access_closed": canAccessClosed,
            "photo_200_orig": photo200_Orig,
            "track_code": trackCode
        ]
    }
}

