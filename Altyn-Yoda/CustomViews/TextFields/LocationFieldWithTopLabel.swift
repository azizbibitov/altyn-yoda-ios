//
//  EditableTextFieldWithTopLabel.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 10.04.2023.
//

import UIKit
import EasyPeasy

class LocationFieldWithTopLabel: UIStackView {
    
    var label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .textColor
        lbl.font = .interSemiBold(size: 12)
        return lbl
    }()
    
    var innerBtn: ZFRippleButton = {
        let btn = ZFRippleButton()
        btn.layer.cornerRadius = 4
        btn.setImage(UIImage(named: "location-add")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .textColor
        btn.addTarget(self, action: #selector(innerButtonClick), for: .touchUpInside)
        btn.easy.layout(Height(30))
        btn.ripplePercent = 2
        btn.trackTouchLocation = true
        btn.rippleColor = .hoverColor!
        btn.rippleBackgroundColor = .white.withAlphaComponent(0.3)
        btn.imageView?.easy.layout([Trailing(8), Size(24)])
        return btn
    }()
    
    let locationId = GoldenWayLabel(font: .interRegular(size: 12), color: UIColor.textColor, alignment: .left, text: "choose_location_coordinate".localized())
    
    var innerBtnClickCallback: ( () -> Void )?
    
    var textField = PaddingTextField()
    
    init(lbl: String = "", pl: String = ""){
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
        addArrangedSubview(locationId)
        
    }
    
    func disable(){
        label.textColor = UIColor.textColor?.withAlphaComponent(0.4)
        textField.textColor = UIColor.textColor?.withAlphaComponent(0.4)
        textField.layer.borderColor = UIColor.textColor?.withAlphaComponent(0.4).cgColor
        textField.isEnabled = false
        innerBtn.tintColor = UIColor.textColor?.withAlphaComponent(0.4)
        locationId.textColor = UIColor.textColor?.withAlphaComponent(0.4)
    }
    
    func enable(){
        label.textColor = UIColor.textColor
        textField.textColor = UIColor.textColor
        textField.layer.borderColor = UIColor.textColor?.cgColor
        textField.isEnabled = true
        innerBtn.tintColor = .textColor
        locationId.textColor = .textColor
    }
    
    func locationAdded(){
        innerBtn.setImage(UIImage(named: "location-tick")?.withRenderingMode(.alwaysTemplate), for: .normal)
        innerBtn.tintColor = .primaryColor
    }
    
    @objc func innerButtonClick(){
        innerBtnClickCallback?()
    }
    
    func normal(){
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
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    
}
