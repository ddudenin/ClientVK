//
//  UsefulFunctions.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 23.03.2021.
//

import Foundation
import UIKit
import RealmSwift

func convertCountToString<T: BinaryInteger>(count number: T) -> String {
    let unitAbbreviations = ["K", "M", "B"]
    
    var value = Float(number)
    var index = -1
    
    while value >= 1000 {
        value /= 1000
        index += 1
    }
    
    guard index != -1 else { return "\(number)" }
    
    return  String(format: "%.1f", value) + unitAbbreviations[index]
}

func utcToTimeAgoDisplay(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let relativeFormatter = RelativeDateTimeFormatter()
    relativeFormatter.unitsStyle = .full
    
    return relativeFormatter.localizedString(for: dateFormatter.date(from: dateString) ?? Date(timeIntervalSinceNow: 0), relativeTo: Date())
}
