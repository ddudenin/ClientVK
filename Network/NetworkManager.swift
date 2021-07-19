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
    
    func loadFriends(complition: @escaping ([RLMUser]) -> ()) {
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
                        .decode(FriendsRequestData.self, from: data)
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
    
    func friendsForecast() -> Promise<[RLMUser]> {
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
        
        guard let url = urlComponents.url else { return .value([])}
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url)
        dataTask.resume()
        
        return firstly {
            session.dataTask(.promise, with: url)
        }.compactMap {
            return try self.decoder
                .decode(FriendsRequestData.self, from: $0.data)
                .response.items
        }
    }
    
    func loadPhotos(userId: Int, complition: @escaping ([RLMPhoto]) -> ()) {
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
                        .decode(PhotosRequestData.self, from: data)
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
    
    func loadAlbums(userId: Int, complition: @escaping ([Album]) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.getAlbums"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "owner_id", value: "\(userId)"),
            URLQueryItem(name: "need_system", value: "1"),
            URLQueryItem(name: "need_covers", value: "1"),
            URLQueryItem(name: "photo_sizes", value: "1"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let albums = try self.decoder
                        .decode(AlbumsRequestData.self, from: data)
                        .response.items
                    complition(albums)
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
    
    func loadGroups(searchText: String, complition: @escaping ([RLMGroup]) -> ()) {
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
                        .decode(GroupsRequestData.self, from: data)
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
    
    func loadPosts(startFrom: String = "", startTime: Double? = nil, complition: @escaping (PostResponse) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/newsfeed.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "start_from", value: "\(startFrom)"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        if let time = startTime {
            urlComponents.queryItems?.append(URLQueryItem(name: "start_time", value: "\(time)"))
        }
        
        guard let url = urlComponents.url else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let response = try self.decoder
                        .decode(PostRequestData.self, from: data)
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
