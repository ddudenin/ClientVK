//
//  NetworkManager.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 3/18/21.
//

import Foundation

class NetworkManager {
    static let instance = NetworkManager()
    
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
                    let friends = try JSONDecoder().decode(FriendsJSONData.self, from: data).response.items
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
    
    func loadGroups(complition: @escaping ([Group]) -> ()) {
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
    
    func loadNews(complition: @escaping ([Article]) -> ()){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/top-headlines"
        urlComponents.queryItems = [
            URLQueryItem(name: "apiKey", value: "ec8c5767456c45f3af8ba865c95b4723"),
            URLQueryItem(name: "country", value: "gb")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let news = try JSONDecoder().decode(NewsJSONData.self, from: data).articles
                    complition(news)
                }  catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
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
