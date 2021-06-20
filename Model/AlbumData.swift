//
//  AlbumData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 07.06.2021.
//

import Foundation
import UIKit

struct AlbumsJSONData: Codable {
    let response: AlbumResponse
}

struct AlbumResponse: Codable {
    let count: Int
    let items: [Album]
}

struct Album: Codable {
    let id, thumbId, ownerId: Int
    let title: String
    let itemDescription: String?
    let created, updated: Int?
    let size: Int
    let sizes: [Thumb]
}

class Thumb: Codable {
    var height: Int = 0
    var src: String = ""
    var type: String = ""
    var width: Int = 0
    
    var aspectRatio: CGFloat { return CGFloat(self.height) / CGFloat(self.width) }
}
