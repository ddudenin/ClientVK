//
//  PhotoDisplayItemFactory.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 21.06.2021.
//

import UIKit

enum PhotoDisplayItemFactory {
    static func make(for photo: RLMPhoto) -> PhotoDisplayItem {
        let photoURL = photo.sizes.last?.url ?? ""
        let likesInfo = photo.likes ?? Likes()
        
        return PhotoDisplayItem(photoURL: photoURL, likes: likesInfo)
    }
}
