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

struct GroupDTO {
    let id: Int
    let name: String
    let photo200: String
}

class ServiceAdapter: INetworkService {
    
    let networkManager = NetworkManager.instance
    let realmManager = RealmManager.instance
    private var usersToken: NotificationToken?
    private var groupsToken: NotificationToken?
    
    func loadFriends(complition: @escaping ([UserDTO]) -> ()) {
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
                let friends: Results<RLMUser>? = self.realmManager?.getObjects()
                self.getUserData(users: friends, complition: complition)
            }
    }
    
    func getUserData(users: Results<RLMUser>?, complition: @escaping ([UserDTO]) -> ())
    {
        self.usersToken = users?.observe { [weak self] (change) in
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
    
    func loadGroups(complition: @escaping ([GroupDTO]) -> ()) {
        let queue = OperationQueue()
        
        let fetchOP = FetchDataOperation()
        queue.addOperation(fetchOP)
        
        let parseOP = ParseDataOperation()
        parseOP.addDependency(fetchOP)
        queue.addOperation(parseOP)
        
        let saveOP = SaveToRealmOperation()
        saveOP.addDependency(parseOP)
        OperationQueue.main.addOperation(saveOP)
        
        let completionOperation = BlockOperation {
            let groups: Results<RLMGroup>? = self.realmManager?.getObjects()
            self.getGroupData(groups: groups, complition: complition)
        }
        
        completionOperation.addDependency(saveOP)
        OperationQueue.main.addOperation(completionOperation)
    }
    
    func getGroupData(groups: Results<RLMGroup>?, complition: @escaping ([GroupDTO]) -> ())
    {
        self.usersToken = groups?.observe { [weak self] (change) in
            guard let self = self else { return }
            switch change {
            case .initial(let groups):
                let items = Array(groups.compactMap(self.makeUser))
                complition(items)
            case .update(_, deletions: _, insertions: _, modifications: _):
                break
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func makeUser(from object: RLMGroup) -> GroupDTO {
        return GroupDTO(
            id: object.id,
            name: object.name,
            photo200: object.photo200)
    }
}
