//
//  ServiceAdapter.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 27.06.2021.
//

import Foundation
import RealmSwift

struct UserDTO {
    let firstName: String
    let id: Int
    let lastName: String
    let photo200Orig: String
    
    var fullName: String  {
        return firstName + " " + lastName
    }
}

class ServiceAdapter {
    
    let networkManager = NetworkManager.instance
    let realmManager = RealmManager.instance
    private var notificationToken: NotificationToken?
    
    func loadFriends(complition: @escaping ([UserDTO]) -> ()) {
        var friends: Results<RLMUser>? = self.realmManager?.getObjects()
        
        if let _ = friends?.count {
            getUserData(users: friends, complition: complition)
        }
        
        self.networkManager.friendsForecast()
            .map { friends in
                do {
                    try self.realmManager?.add(objects: friends)
                } catch {
                    print(error.localizedDescription)
                }
            }
            .catch { error in
                print(error.localizedDescription)
            }
            .finally {
                friends = self.realmManager?.getObjects()
                self.getUserData(users: friends, complition: complition)
            }
    }
    
    private func getUserData(users: Results<RLMUser>?,
                             complition: @escaping ([UserDTO]) -> ())
    {
        self.notificationToken = users?.observe { [weak self] (change) in
            guard let self = self else { return }
            switch change {
            case .initial(let friends):
                let items = Array(friends.compactMap(self.makeUser))
                complition(items)
            case .update(_, deletions: _, insertions: _, modifications: _):
                break
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func makeUser(from object: RLMUser) -> UserDTO {
        return UserDTO(
            firstName: object.firstName,
            id: object.id,
            lastName: object.lastName,
            photo200Orig: object.photo200Orig)
    }
}
