//
//  UILabel.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 29.04.2023.
//


import UIKit.UILabel

extension UILabel {
    
    func setText(_ text: String, withColorPart colorTextPart: String, color: UIColor) {
        attributedText = nil
        let result =  NSMutableAttributedString(string: text)
        result.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSString(string: text.lowercased()).range(of: colorTextPart.lowercased()))
        attributedText = result
    }
    
    func setFontText(_ text: String, withFontPart fontTextPart: String, font: UIFont) {
        attributedText = nil
        let result =  NSMutableAttributedString(string: text)
        result.addAttribute(NSAttributedString.Key.font, value: font, range: NSString(string: text.lowercased()).range(of: fontTextPart.lowercased()))
        attributedText = result
    }
    
    convenience init(
        text: String = "",
        font: UIFont = .interRegular(size: 20),
        color: UIColor = UIColor(named: "textColor")!,
        align: NSTextAlignment = .left
    )
    {
        self.init()
        self.text = text
        self.font = font
        self.textColor = color
        self.textAlignment = align
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.translatesAutoresizingMaskIntoConstraints  = false
    }

}
