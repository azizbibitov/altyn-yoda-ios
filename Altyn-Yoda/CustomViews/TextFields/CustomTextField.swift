//
//  CustomTextField.swift
//  SalamExpress
//
//  Created by Parahat Caryyew on 12.02.2023.
//

import UIKit
import EasyPeasy

class CustomTextField: UIStackView {
    
    var label = UILabel(font: .interSemiBold(size: 12))
    var textField = PaddingTextField()
    
    init(lbl: String = "", pl: String = ""){
        super.init(frame: .zero)
        self.axis = .vertical
        self.alignment = .fill
        self.spacing = 6
        
        self.label.text = lbl
        self.textField.placeholder = pl
        
        addArrangedSubview(label)
        addArrangedSubview(textField)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func disable(){
        label.textColor = UIColor.textColor?.withAlphaComponent(0.4)
        textField.textColor = UIColor.textColor?.withAlphaComponent(0.4)
        textField.layer.borderColor = UIColor.textColor?.withAlphaComponent(0.4).cgColor
        textField.isEnabled = false
    }
    
    func enable(){
        label.textColor = UIColor.textColor
        textField.textColor = UIColor.textColor
        textField.layer.borderColor = UIColor.textColor?.cgColor
        textField.isEnabled = true
    }
    
    func normal(){
        textField.layer.borderColor = UIColor(named: "textColor")?.cgColor
    }
    
    func focused(){
        textField.layer.borderColor = UIColor(named: "secondaryColor")?.cgColor
    }
    
    func error(){
        textField.layer.borderColor = UIColor(named: "errorColor")?.cgColor
    }
    
    func checkIfEmpty() -> Bool {
        if textField.text == "" {
            error()
            return true
        }else{
            normal()
            return false
        }
    }
    
}

