//
//  AlbumData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 07.06.2021.
//

import Foundation

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
    let thumbSrc: String
}
