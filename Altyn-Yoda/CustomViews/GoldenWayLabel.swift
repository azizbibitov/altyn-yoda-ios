//
//  MIULabel.swift
//  MIU-LOVE
//
//  Created by Aziz's MacBook Air on 28.02.2023.
//

import UIKit

class GoldenWayLabel: UILabel {
    
    init(font: UIFont, color: UIColor?, alignment: NSTextAlignment = .center, numberOfLines: Int = 0, text: String = "") {
        super.init(frame: .zero)
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
