//
//  SafeAreaInsets.swift
//  Salam-beta
//
//  Created by Shirin on 03.04.2022.
//

import UIKit


class DeviceDimensions {
    
    static let shared = DeviceDimensions()

    func keyWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    func bottomInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            return keyWindow()?.safeAreaInsets.bottom ?? 0
        }
        
        return 0
    }
    
    func topInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            return keyWindow()?.safeAreaInsets.top ?? 0
        }
        
        return 0
    }
    
    func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func isDeviceIpad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    func width() -> CGFloat {
        return keyWindow()?.frame.size.width ?? 0
    }
    
    func height() -> CGFloat {
        return keyWindow()?.frame.size.height ?? 0
    }
    
    func safeAreaHeight() -> CGFloat {
        return height() - bottomInset() - topInset()
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}
