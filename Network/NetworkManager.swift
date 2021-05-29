//
//  NetworkManager.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 18.03.2021.
//

import Foundation
import PromiseKit

class NetworkManager {
    static let instance = NetworkManager()
    
    lazy var decoder: JSONDecoder = {
        var decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private init() {
        
    }
    
    func loadFriends(complition: @escaping ([User]) -> ()) {
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
                    let friends = try self.decoder
                        .decode(FriendsJSONData.self, from: data)
                        .response.items
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
    
    func friendsForecast() -> Promise<[User]> {
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
        
        guard let url = urlComponents.url else { return .value([User]())}
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url)
        dataTask.resume()
        
        return firstly {
            session.dataTask(.promise, with: url)
        }.compactMap {
            return try self.decoder
                .decode(FriendsJSONData.self, from: $0.data)
                .response.items
        }
    }
    
    func loadPhotos(userId: Int, complition: @escaping ([Photo]) -> ()) {
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
                    let photos = try self.decoder
                        .decode(PhotosJSONData.self, from: data)
                        .response.items
                    complition(photos)
                } catch {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        dataTask.resume()
        
    }
    
    func loadGroups(complition: @escaping (Data?) -> ()) {
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
            if let error = error {
                print(error.localizedDescription)
            }
            
            complition(data)
        }
        
        dataTask.resume()
    }
    
    func loadGroups(searchText: String, complition: @escaping ([Group]) -> ()) {
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
                    let groups = try self.decoder
                        .decode(GroupsJSONData.self, from: data)
                        .response.items
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
    
    func loadPosts(complition: @escaping (PostResponse) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/newsfeed.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let response = try self.decoder
                        .decode(PostJSONData.self, from: data)
                        .response
                    complition(response)
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
