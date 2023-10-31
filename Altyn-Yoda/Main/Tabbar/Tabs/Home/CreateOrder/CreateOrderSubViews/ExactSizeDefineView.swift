//
//  ExactSizeDefineView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 10.04.2023.
//

import UIKit
import EasyPeasy

class ExactSizeDefineView: UIView {
  
    var weightGRLabel = UILabel(text: "KG   ", font: .interSemiBold(size: 16), align: .left)
    var weightField = CustomTextField(lbl: "weight_kg".localized(), pl: "")
    
    var horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.distribution = .fill
        return stack
    }()
    
    let gabaritsLabel = GoldenWayLabel(font: .interSemiBold(size: 14), color: UIColor.textColor, alignment: .left, text: "gabarits_sm".localized())
    
    var lengthTextField = SizeTextField(lbl: "length".localized())
    var widthTextField = SizeTextField(lbl: "width".localized())
    var heightTextField = SizeTextField(lbl: "height".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(weightField)
        weightField.easy.layout([
            Top(), Leading(), Trailing()//, Bottom()
        ])
        
        weightGRLabel.backgroundColor = .whiteBlackColor
        weightField.textField.rightView = weightGRLabel
        weightField.textField.rightViewMode = .unlessEditing
        weightField.textField.keyboardType = .numberPad
        
        addSubview(horizontalStack)
        horizontalStack.easy.layout([
            Trailing(), Top(16).to(weightField, .bottom), Bottom(), Width((DeviceDimensions.shared.screenWidth()-40)/1.4)
        ])
        
        horizontalStack.addArrangedSubview(lengthTextField)
        horizontalStack.addArrangedSubview(widthTextField)
        horizontalStack.addArrangedSubview(heightTextField)
        
        addSubview(gabaritsLabel)
        gabaritsLabel.easy.layout([
            CenterY().to(horizontalStack, .centerY), Leading(), Trailing().to(horizontalStack, .leading)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
