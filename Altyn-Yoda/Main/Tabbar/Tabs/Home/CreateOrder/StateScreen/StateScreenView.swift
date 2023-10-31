//
//  StateScreenView.swift
//  SalamExpress
//
//  Created by Aziz's MacBook Air on 27.03.2023.
//

import UIKit
import EasyPeasy

class StateScreenView: UIView {
    
    let successView = RequestSuccessView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteBlackColor
        
        addSubview(successView)
        successView.easy.layout(Edges())
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
