//
//  UIScrollView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 22.04.2023.
//

import UIKit.UIScrollView

extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)+1
    }
}
