//
//  Session.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 16.03.2021.
//

import Foundation

class Session {
    
    static let instance = Session()
    
    var token: String
    var userId: Int
    
    private init() {
        token = ""
        userId = 0
    }
}
