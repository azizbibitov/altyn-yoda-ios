//
//  CustomActionPopupContainerView.swift
//  MIU-LOVE
//
//  Created by Aziz's MacBook Air on 09.03.2023.
//

import UIKit

class GoldenWayActionPopupContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor = .backgroundColor
        layer.cornerRadius    = 8
        translatesAutoresizingMaskIntoConstraints = false
    }
}
