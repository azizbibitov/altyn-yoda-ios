//
//  TextFrameWithButtonAndTopLbl.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 08.04.2023.
//

import UIKit

class TextFrameWithBtnAndTopLbl: UIStackView {
    
    var label = UILabel(font: .interMedium(size: 14))
    var button = TextFrameWithButton(title: "")
    
    init(lbl: String, pl: String, fSize: CGFloat = 16, isRegular: Bool = true, icon: String = ""){
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = 4
        self.alignment = .fill
        self.addArrangedSubview(label)
        self.addArrangedSubview(button)
        label.text = lbl
        button.setTitle(pl, for: .normal)
        button.innerBtn.setImage(UIImage(named: icon)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.titleLabel?.font = isRegular ? .interRegular(size: fSize) : .interMedium(size: fSize)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
