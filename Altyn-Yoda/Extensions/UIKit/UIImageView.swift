//
//  UIImageView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 13.04.2023.
//

import UIKit
import EasyPeasy

extension UIImageView {
    
    convenience init(name: String, width: CGFloat, height: CGFloat){
        self.init()
        self.image = UIImage(named: name)
        self.easy.layout([
            Width(width),
            Height(height)
        ])
    }
    convenience init(name: String, size: CGFloat, cr: CGFloat = 0){
        self.init()
        self.image = UIImage(named: name)
        self.easy.layout([
            Size(size)
        ])
        self.layer.cornerRadius = cr
    }
    convenience init(name: String){
        self.init()
        self.image = UIImage(named: name)
    }
}
