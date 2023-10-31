//
//  DateTextFieldWithTopLabel.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 15.04.2023.
//

import UIKit
import EasyPeasy

class DateTextFieldWithTopLabel: UIStackView {
    
    var isTimePicker: Bool = false
    
    var label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .textColor
        lbl.font = .interSemiBold(size: 12)
        return lbl
    }()
    
    var innerBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 4
        btn.easy.layout(Height(30))
        btn.tintColor = .textColor
        btn.imageView?.easy.layout([Trailing(8), Size(24)])
//        btn.ripplePercent = 2
//        btn.trackTouchLocation = true
//        btn.rippleColor = .hoverColor!
//        btn.rippleBackgroundColor = .white.withAlphaComponent(0.3)
//        btn.addTarget(self, action: #selector(innerBtnTap), for: .touchUpInside)
        return btn
    }()
    
    var textField = PaddingTextField()
    
    var doneCallback: ( (_ date: String) -> Void )?
    
    var doneClickedCallBack: ( ()->Void )?
    
//    var innerBtnClickedCallBack: ( ()->Void )?
    
    var pickerToolbar: UIToolbar?
    lazy var datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
        datePicker.setDate("2000-01-01T00:00:00.00001Z".getDate() ?? Date(), animated: false)
        datePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        return datePicker
    }()
    
    init(lbl: String = "", pl: String = "", icon: String){
        super.init(frame: .zero)
        axis = .vertical
        alignment = .fill
        spacing = 6
        
        label.text = lbl
        
        textField.rightView = innerBtn
        textField.rightViewMode = .unlessEditing
        
        textField.layer.borderColor = UIColor.textColor?.cgColor
        
        addArrangedSubview(label)
        addArrangedSubview(textField)
        
        innerBtn.setImage(UIImage(named: icon)?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    func setupWithDatePicker(isTimePicker: Bool){
        if isTimePicker {
            datePicker.datePickerMode = .time
        }else{
            datePicker.datePickerMode = .date
        }
        
        createUIToolBar()
        textField.inputAccessoryView = pickerToolbar
        textField.inputView = datePicker
    }
    
    func createUIToolBar() {
        pickerToolbar = UIToolbar()
        pickerToolbar?.autoresizingMask = .flexibleHeight
        pickerToolbar?.backgroundColor = UIColor.white
        pickerToolbar?.isTranslucent = false
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClicked(_:)))
        cancelButton.tintColor = UIColor.textColor
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnClicked(_:)))
        doneButton.tintColor = UIColor.textColor

        pickerToolbar?.items = [cancelButton, flexSpace, doneButton]
    }
    
    @objc func cancelBtnClicked(_ button: UIBarButtonItem?) {
        textField.resignFirstResponder()
    }
    
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        textField.resignFirstResponder()
        let formatter = DateFormatter()
        
        if isTimePicker {
            formatter.timeStyle = .short
            textField.text = formatter.string(from: datePicker.date)
        }else{
            formatter.dateFormat = "yyyy-MM-dd"
            textField.text = formatter.string(from: datePicker.date)
        }
       
        
        
        doneCallback?(formatter.string(from: datePicker.date))
        
        doneClickedCallBack?()
        
    }
    
//    @objc func innerBtnTap() {
//        innerBtnClickedCallBack?()
////        textField.endEditing(true)
//        textField.becomeFirstResponder()
//    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    
}

