//
//  PhotoCacheService.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 26.05.2021.
//

import Foundation
import UIKit


final class PhotoCacheService {
    
    static let shared = PhotoCacheService()
    
    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    
    private static let path: String = {
        let pathDirName = "Images"
        
        guard let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathDirName }
        
        let imagesDirName = cachesDir.appendingPathComponent(pathDirName)
        
        var isDirectory: ObjCBool = true
        
        if FileManager.default.fileExists(atPath: imagesDirName.path, isDirectory: &isDirectory), isDirectory.boolValue == true {
            return pathDirName
        } else {
            try? FileManager.default.createDirectory(at: imagesDirName, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathDirName
    }()
    
    private var images: [String: UIImage] = [:]
    
    func photo(by url: String, completion: @escaping (UIImage?) -> Void) {
        var image: UIImage?
        
        if let photo = self.images[url] {
            image =  photo
        } else if let photo = self.getImageFromCache(at: url) {
            image = photo
        } else {
            self.loadImage(from: URL(string: url)!) { image in
                completion(image)
            }
        }
        
        DispatchQueue.main.async {
            completion(image)
        }
    }
    
    private func getFilePath(at url: String) -> String? {
        guard let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let imageName = String(url.split(separator: "/").last ?? "default")
        
        return cachesURL
            .appendingPathComponent(Self.path)
            .appendingPathComponent(imageName)
            .path
    }
    
    private func saveImageToCache(_ image: UIImage, at path: String) {
        guard let filePath = self.getFilePath(at: path) else { return }
        guard let data = image.pngData() else { return }
        
        FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
    }
    
    private func getImageFromCache(at path: String) -> UIImage? {
        guard let filePath = self.getFilePath(at: path) else { return nil }
        guard let info = try? FileManager.default.attributesOfItem(atPath: filePath),
              let modificationDate = info[.modificationDate] as? Date
        else { return nil }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        if lifeTime <= self.cacheLifeTime, let image = UIImage(contentsOfFile: filePath) {
            
            DispatchQueue.main.async {
                self.images[filePath] = image
            }
            
            return image
        } else {
            return nil
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                self?.images[url.path] = image
            }
            
            self?.saveImageToCache(image, at: url.path)
            
            completion(image)
        }
        
        dataTask.resume()
    }
}


extension UIImageView {
    func setImage(at url: String, placeholderImage: UIImage? = nil) {
        self.image = placeholderImage
        
        PhotoCacheService.shared.photo(by: url) { [weak self] image in
            guard let image = image else { return }
            self?.image = image
        }
    }
}
