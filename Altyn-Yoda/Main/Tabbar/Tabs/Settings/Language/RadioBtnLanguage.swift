//
//  RadioBtnLanguage.swift
//  SalamExpress
//
//  Created by Aziz's MacBook Air on 17.03.2023.
//

import UIKit
import EasyPeasy

class RadioBtnLanguage: UIView {

    let inner = UIView()

    init(innerColor: UIColor = .white, outerColor: UIColor = .primaryColor! ) {
        super.init(frame: .zero)
        
        self.backgroundColor = outerColor
        self.layer.cornerRadius = 10
        self.easy.layout(Size(20))
        self.addSubview(inner)
        inner.backgroundColor = innerColor
        setState(isSelected: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setState(isSelected: Bool) {
        inner.easy.layout([Size(isSelected ? 8 : 16), Center()])
        inner.layer.cornerRadius =  isSelected ? 4 : 8
    }
    
}

