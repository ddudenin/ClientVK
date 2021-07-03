//
//  Proxy.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 03.07.2021.
//

import Foundation
import RealmSwift

protocol INetworkService {
    func loadFriends(complition: @escaping ([UserDTO]) -> ())
    func loadGroups(complition: @escaping ([GroupDTO]) -> ())
    func getUserData(users: Results<RLMUser>?, complition: @escaping ([UserDTO]) -> ())
    func getGroupData(groups: Results<RLMGroup>?, complition: @escaping ([GroupDTO]) -> ())
}

class ProxyNetworkService: INetworkService {

    let base: INetworkService
    let realmManager = RealmManager.instance
    
    init(base: INetworkService) {
        self.base = base
    }
    
    func loadFriends(complition: @escaping ([UserDTO]) -> ()) {
        let friends: Results<RLMUser>? = self.realmManager?.getObjects()
        
        if let _ = friends?.count {
            print("Load friends from Realm")
            getUserData(users: friends, complition: complition)
        } else {
            print("Make request to VK service")
            self.base.loadFriends(complition: complition)
        }
    }
    
    func loadGroups(complition: @escaping ([GroupDTO]) -> ()) {
        let groups: Results<RLMGroup>? = self.realmManager?.getObjects()
        
        if let _ = groups?.count {
            print("Load groups from Realm")
            getGroupData(groups: groups, complition: complition)
        } else {
            print("Make request to VK service")
            self.base.loadGroups(complition: complition)
        }
    }
    
    func getUserData(users: Results<RLMUser>?, complition: @escaping ([UserDTO]) -> ()) {
        self.base.getUserData(users: users, complition: complition)
    }
    
    func getGroupData(groups: Results<RLMGroup>?, complition: @escaping ([GroupDTO]) -> ()) {
        self.base.getGroupData(groups: groups, complition: complition)
    }
}
