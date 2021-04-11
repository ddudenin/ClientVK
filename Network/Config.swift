//
//  Config.swift
//  Swift_CustomApp
//
//  Created by user192247 on 4/11/21.
//

import Foundation

enum DatabaseType {
    case database, firestore
}

enum Config {
    static let databaseType = DatabaseType.firestore
}
