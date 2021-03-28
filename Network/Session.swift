//
//  Session.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 3/16/21.
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
