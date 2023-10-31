//
//  MultilineTextFieldWithTopLabel.swift
//  MIU-LOVE
//
//  Created by Aziz's MacBook Air on 22.03.2023.
//

import UIKit
import EasyPeasy

class MultilineTextFieldWithTopLabel: UIStackView {
    
    var label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .textColor
        lbl.font = .interMedium(size: 14)
        return lbl
    }()
    
    var multilineTextField: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.textColor = .textColor
        textView.backgroundColor = .clear
        textView.text = ""
        return textView
    }()
    
    init(lbl: String = "", pl: String = ""){
        super.init(frame: .zero)
        axis = .vertical
        alignment = .fill
        spacing = 6
        
        label.text = lbl
//        multilineTextField.placeholder = pl
        multilineTextField.layer.cornerRadius = 8
        multilineTextField.layer.borderWidth = 2
        multilineTextField.font = .interMedium(size: 20)
        
        addArrangedSubview(label)
        addArrangedSubview(multilineTextField)
        normal()
        
        multilineTextField.delegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func normal(){
        multilineTextField.layer.borderColor = UIColor.textColor?.cgColor
    }
//
//    func focused(){
//        textField.layer.borderColor = UIColor.miuGreenColor?.cgColor
//    }
//
//    func error(){
//        textField.layer.borderColor = UIColor.miuRedColor?.cgColor
//    }
    
}

extension MultilineTextFieldWithTopLabel: UITextViewDelegate {
    func textViewDidBeginEditing (_ textView: UITextView) {
        if multilineTextField.textColor == .lightGray && multilineTextField.isFirstResponder {
            multilineTextField.text = nil
            multilineTextField.textColor = .textColor
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if multilineTextField.text.isEmpty || multilineTextField.text == "" {
            multilineTextField.textColor = .lightGray
            multilineTextField.text = ""
        }
    }
}
