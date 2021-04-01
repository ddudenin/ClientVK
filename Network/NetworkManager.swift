//
//  NetworkManager.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 3/18/21.
//

import Foundation
import RealmSwift

class NetworkManager {
    static let instance = NetworkManager()
    
    private init() {
        
    }
    
    private let realm: Realm? = {
        #if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm Error")
        #endif
        
        return try? Realm()
    }()
    
    func loadFriends(complition: @escaping ([FriendItem]) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "fields", value: "name, photo_200_orig"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let friends = try JSONDecoder().decode(FriendsJSONData.self, from: data).response.items
                    self.saveFriendsData(friends: friends)
                    complition(friends)
                } catch {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        dataTask.resume()
    }
    
    private func saveFriendsData(friends: [FriendItem]) {
        DispatchQueue.main.async {
            do {
                self.realm?.beginWrite()
                self.realm?.add(friends)
                try self.realm?.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func loadPhotos(userId: Int, complition: @escaping ([PhotoItem]) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.getAll"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "owner_id", value: "\(userId)"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let photos = try JSONDecoder().decode(PhotosJSONData.self, from: data)
                    complition(photos.response.items)
                } catch {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        dataTask.resume()
    }
    
    private func savePhotosData(photos: [PhotoItem]) {
        DispatchQueue.main.async {
            do {
                self.realm?.beginWrite()
                self.realm?.add(photos, update: .all)
                try self.realm?.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadGroups(complition: @escaping ([GroupItem]) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let groups = try JSONDecoder().decode(GroupsJSONData.self, from: data).response.items
                    self.saveGroupsData(groups: groups)
                    complition(groups)
                } catch {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        dataTask.resume()
    }
    
    private func saveGroupsData(groups: [GroupItem]) {
        DispatchQueue.main.async {
            do {
                self.realm?.beginWrite()
                self.realm?.add(groups)
                try self.realm?.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadGroups(searchText: String, complition: @escaping ([GroupItem]) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "count", value: "5"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let groups = try JSONDecoder().decode(GroupsJSONData.self, from: data)
                    complition(groups.response.items)
                } catch {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        dataTask.resume()
    }
}
