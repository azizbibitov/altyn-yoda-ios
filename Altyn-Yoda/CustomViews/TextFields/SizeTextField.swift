//
//  SizeTextField.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 10.04.2023.
//


import UIKit
import EasyPeasy

class SizeTextField: UIStackView {
    
    var label = UILabel(font: .interRegular(size: 12))
    var textField = PaddingTextField(isDimensionTF: true)
    
    init(lbl: String = "", value: String = "0"){
        super.init(frame: .zero)
        self.axis = .vertical
        self.alignment = .fill
        self.spacing = 6
        
        self.label.text = lbl
        self.textField.placeholder = value
        self.textField.keyboardType = .decimalPad
        self.textField.font = .interMedium(size: 20)
        self.textField.easy.layout(Height(50))
        
        addArrangedSubview(label)
        addArrangedSubview(textField)
        
        textField.delegate = self
        textField.layer.borderColor = UIColor.textColor?.cgColor
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func normal(){
//        layer.borderColor = UIColor.textColor?.cgColor
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(named: "textColor")?.cgColor
     
    }
    
    func focused(){
        textField.backgroundColor = .primaryColor?.withAlphaComponent(0.1)
        textField.layer.borderColor = UIColor(named: "textColor")?.cgColor
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

extension SizeTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        focused()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textFieldText = textField.text else { return }
        if textFieldText.isEmpty {
            textField.text = "0"
        }
        normal()
    }
    
}

