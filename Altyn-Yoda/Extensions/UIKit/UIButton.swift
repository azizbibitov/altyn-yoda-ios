//
//  UIButton.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 08.04.2023.
//

import UIKit
import EasyPeasy

extension UIButton {
 
    convenience init(iconName: String) {
        self.init(type: .system)
        self.setImage(UIImage(named: iconName), for: .normal)
    }
    
    convenience init(iconName: String,
                     size: CGFloat = 24,
                     color: UIColor,
                     isHidden: Bool = false){
        self.init(type: .system)
        self.tintColor = color
        self.setImage(UIImage(named: iconName), for: .normal)
        self.isHidden = isHidden
        self.easy.layout(Size(size))
    }
    convenience init(iconName: String,
                     width: CGFloat,
                     height: CGFloat,
                     color: UIColor){
        self.init(type: .system)
        self.tintColor = color
        self.setImage(UIImage(named: iconName), for: .normal)
        self.easy.layout([ Width(width), Height(height) ])
    }
}
