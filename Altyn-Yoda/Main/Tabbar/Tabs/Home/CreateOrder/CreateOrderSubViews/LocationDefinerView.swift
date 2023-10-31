//
//  LocationDefinerView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 08.04.2023.
//

import UIKit
import EasyPeasy

class LocationDefinerView: UIView {
    
    let whereFromDefinerView = LocationFieldWithTopLabel(lbl: "where_from".localized())
    
    let whereToDefinerView = LocationFieldWithTopLabel(lbl: "where_to".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(whereFromDefinerView)
        whereFromDefinerView.easy.layout([
            Leading(), Top(), Trailing()
        ])
        
        
        addSubview(whereToDefinerView)
        whereToDefinerView.easy.layout([
            Leading(), Top(6).to(whereFromDefinerView, .bottom), Bottom(), Trailing()
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
