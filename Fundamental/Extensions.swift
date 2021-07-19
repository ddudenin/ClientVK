//
//  Extensions.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 20.06.2021.
//

import UIKit

extension UIColor {
    
    static let gradientBegin = UIColor(red: 0.02, green: 0.36, blue: 0.91, alpha: 1.00)
    static let gradientEnd = UIColor(red: 0.04, green: 0.78, blue: 0.98, alpha: 1.00)
}

extension UIColor {
    private static var colorsCache: [String: UIColor] = [:]
    
    public static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat) -> UIColor {
        let key = "\(red), \(green), \(blue), \(alpha)"
        
        if let cachedColor = self.colorsCache[key] {
            return cachedColor
        }
        
        self.clearColorsCacheIfNeeded()
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        self.colorsCache[key] = color
        return color
    }
    
    private static func clearColorsCacheIfNeeded() {
        guard self.colorsCache.count >= 100 else { return }
        colorsCache = [:]
    }
}

extension UIFont {
    static let systemFont12 = UIFont.systemFont(ofSize: 12)
    static let systemFont15 = UIFont.systemFont(ofSize: 15)
    static let systemFont15Bold = UIFont.systemFont(ofSize: 15, weight: .semibold)
}
