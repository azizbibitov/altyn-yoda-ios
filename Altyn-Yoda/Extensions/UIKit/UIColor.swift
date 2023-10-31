//
//  UIColor.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 25.03.2023.
//

import UIKit.UIColor

extension UIColor {
    
    static let oneTimeFieldColor = UIColor(named: "oneTimeFieldColor")
    
    static let tabBackColor = UIColor(named: "tabBackColor")
    
    static let btnBlackYellowColor = UIColor(named: "btnBlackYellowColor")
    
    static let noActionPopupColor = UIColor(named: "noActionPopupColor")
    
    static let photoCollectionColor = UIColor(named: "photoCollectionColor")
    
    static let serviceCellColor = UIColor(named: "serviceCellColor")
    
    static let whiteBlackForBtn = UIColor(named: "whiteBlackForBtn")
    
    static let blackBtnHover = UIColor(named: "blackBtnHover")
    
    static let yellowWarningColor = UIColor(named: "yellowWarningColor")
    
    static let whiteBlackColor = UIColor(named: "whiteBlackColor")
    
    static let customBtnBack = UIColor(named: "customBtnBack")
    
    static let backgroundColor = UIColor(named: "backgroundColor")
    
    static let errorColor = UIColor(named: "errorColor")
    
    static let hoverColor = UIColor(named: "hoverColor")
    
    static let primaryColor = UIColor(named: "primaryColor")
    
    static let secondaryColor = UIColor(named: "secondaryColor")
    
    static let textColor = UIColor(named: "textColor")
    
    static let gray95 = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    static let black28 = UIColor(red: 0.28, green: 0.28, blue: 0.28, alpha: 1)
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
