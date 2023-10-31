//
//  TextFieldBackground.swift
//  Salam-Express
//
//  Created by Aziz's MacBook Air on 11.02.2023.
//

import UIKit

class TextFieldFrame: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    func configure(){
        normalState()
        layer.borderWidth = 0.5
        layer.cornerRadius = 6
    }
    
    func normalState(){
        backgroundColor = .clear
        layer.borderColor = UIColor.black.cgColor
    }
    
    func setColor(color: UIColor){
        layer.borderColor = color.cgColor
        backgroundColor = color.withAlphaComponent(0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
