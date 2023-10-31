//
//  UIWindow.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 16.02.2023.
//

import UIKit.UIWindow

extension UIWindow {
    static var key: UIWindow! {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
