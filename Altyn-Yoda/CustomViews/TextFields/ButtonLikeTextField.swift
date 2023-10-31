//
//  ButtonLikeTextField.swift
//  SalamExpress
//
//  Created by Parahat Caryyew on 13.02.2023.
//

import UIKit

class ButtonLikeTextField: UIStackView {
    
    var label = UILabel(font: .interMedium(size: 12))
    var button = ButtonWithIcon(title: "")
    
    init(lbl: String, pl: String, fSize: CGFloat = 14, isRegular: Bool = false){
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = 6
        self.alignment = .fill
        self.addArrangedSubview(label)
        self.addArrangedSubview(button)
        label.text = lbl
        button.setTitle(pl, for: .normal)
        button.titleLabel?.font = isRegular ? .interRegular(size: fSize) : .interMedium(size: fSize)
    }
    
    func disable(){
        label.textColor = UIColor.textColor?.withAlphaComponent(0.4)
        button.setTitleColor(UIColor.textColor?.withAlphaComponent(0.4), for: .normal)
        button.layer.borderColor = UIColor.textColor?.withAlphaComponent(0.4).cgColor
        button.tintColor = UIColor.textColor?.withAlphaComponent(0.4)
        button.isUserInteractionEnabled = false
    }
    
    func enable(){
        label.textColor = UIColor.textColor
        button.setTitleColor(UIColor.textColor, for: .normal)
        button.layer.borderColor = UIColor.textColor?.cgColor
        button.tintColor = .textColor
        button.isUserInteractionEnabled = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
