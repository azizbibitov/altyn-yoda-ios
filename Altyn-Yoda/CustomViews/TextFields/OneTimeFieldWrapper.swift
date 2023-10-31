//
//  OneTimeWrapper.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 04.04.2023.
//

import UIKit
import EasyPeasy

class OneTimeFieldWrapper: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexString: "#F8F6F9")
        layer.borderColor = UIColor(hexString: "#121212").withAlphaComponent(0.24).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
