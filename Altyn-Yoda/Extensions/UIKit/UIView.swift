//
//  UIView.swift
//  Salam-Express
//
//  Created by Aziz's MacBook Air on 11.02.2023.
//

import UIKit.UIView

extension UIView {
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    
//    var textFieldsInView: [UITextField] {
//        return subviews
//            .filter ({ !($0 is UITextField) })
//            .reduce (( subviews.compactMap { $0 as? UITextField }), { summ, current in
//                return summ + current.textFieldsInView
//            })
//    }
//    var selectedTextField: UITextField? {
//        return textFieldsInView.filter { $0.isFirstResponder }.first
//    }
    
    
    
    
}
