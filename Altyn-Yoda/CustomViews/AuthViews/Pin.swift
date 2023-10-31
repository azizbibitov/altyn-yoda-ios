//
//  Pin.swift
//  Salam-beta
//
//  Created by Maksadow Meylis on 22.06.2022.
//

import UIKit
import EasyPeasy

class Pin: UIView {

    let pin = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        pin.backgroundColor = .black
        pin.layer.cornerRadius = 7.5
        pin.layer.masksToBounds = true
        addSubview(pin)

        pin.easy.layout([
            Center(), Size(15)
        ])
    }
}
