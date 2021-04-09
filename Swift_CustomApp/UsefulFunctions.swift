//
//  UsefulFunctions.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 3/23/21.
//

import Foundation
import UIKit
import RealmSwift

//Instead of SDWebImage
func GetImage(fromURL url: String) -> UIImage? {
    guard let imgURL = URL(string: url) else { return .none }
    guard let imgData = try? Data(contentsOf: imgURL) else { return .none }
    
    return UIImage(data: imgData)
}

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

extension Results {
    func toArray() -> [Element] {
        return compactMap { $0 }
    }
}

func generateTimeAgoDisplay() -> String {
    let hour = arc4random_uniform(23)
    let minute = arc4random_uniform(59)
    
    let today = Date(timeIntervalSinceNow: 0)
    let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
    var offsetComponents = DateComponents()
    offsetComponents.hour = -Int(hour)
    offsetComponents.minute = -Int(minute)
    
    let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
    
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    return formatter.localizedString(for: randomDate ?? today, relativeTo: Date())
}
