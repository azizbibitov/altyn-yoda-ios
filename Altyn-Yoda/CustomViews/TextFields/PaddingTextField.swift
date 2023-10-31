//
//  PaddingTextField.swift
//  Altyn-Yoda
//
//  Created by Parahat Caryyew on 12.02.2023.
//

import UIKit
import EasyPeasy

class PaddingTextField: UITextField {
    struct Constants {
        static var sidePadding: CGFloat = 10
        static var topPadding: CGFloat = 14
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + Constants.sidePadding + (leftView?.frame.width ?? 0),
            y: bounds.origin.y + Constants.topPadding,
            width: bounds.size.width - Constants.sidePadding * 2 - (leftView?.frame.width ?? 0),
            height: bounds.size.height - Constants.topPadding * 2
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    init(isDimensionTF: Bool = false) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 1.0
        
        isDimensionTF ? dimensionTF() : normalTF()
        
        Constants.topPadding = isDimensionTF ? 10 : 14
    }
    
    func normalTF(){
        self.layer.borderColor = UIColor.textColor?.cgColor
        self.backgroundColor = .clear
        self.font = .interRegular(size: 14)
        self.textColor = .textColor
        self.easy.layout(Height(45))
    }
    
    func dimensionTF(){
        font = .interMedium(size: 18)
        layer.borderColor = UIColor.primaryColor?.cgColor
        self.easy.layout(Height(40))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

