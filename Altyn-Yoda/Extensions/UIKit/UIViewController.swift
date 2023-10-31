//
//  UIViewController.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 13.04.2023.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func statusBarColorChange() {
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = .whiteBlackColor
            statusBar.tag = 100
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(statusBar)
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = .whiteBlackColor
        }
    }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .primaryColor
        present(safariVC, animated: true)
    }
    
}
