//
//  ThemeUserDefaults.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 16.02.2023.
//

import UIKit

struct ThemeUserDefaults {
    
    static var shared = ThemeUserDefaults()
    
    var theme: Theme {
        get {
            Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .light
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
 
}

enum Theme: Int {
//    case device
    case light = 0
    case dark = 1
    
    @available(iOS 12.0, *)
    func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        switch self {
//        case .device:
//            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
