//
//  TextFrameWithButton.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 08.04.2023.
//

import UIKit
import EasyPeasy

class TextFrameWithButton: UIButton {
    
    var innerBtn: ZFRippleButton = {
        let btn = ZFRippleButton(iconName: "location-add")
        btn.tintColor = .textColor
        btn.contentMode = .center
        btn.layer.cornerRadius = 5
        return btn
    }()

    lazy var clickCallback: ( ()->() )? = nil
    lazy var btnInclickCallback: ( ()->() )? = nil
    
    init(title: String, fsize: CGFloat = 16, icon: String = ""){
        super.init(frame: .zero)
        
        self.titleLabel?.easy.layout([ Leading(10),Width().like(self),  CenterY() ])
        
        self.addSubview(innerBtn)
        innerBtn.easy.layout([
            Leading(4).to(self.titleLabel!, .trailing), Trailing(10), CenterY(), Width(40), Height(30)
        ])
        innerBtn.setImage(UIImage(named: icon)?.withRenderingMode(.alwaysTemplate), for: .normal)
        innerBtn.addTarget(self, action: #selector(buttonInClick), for: .touchUpInside)
        
        self.tintColor = .textColor!
        self.titleLabel?.font = .interRegular(size: fsize)
        self.setTitleColor(.textColor, for: .normal)
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "textColor")?.cgColor
        self.easy.layout(Height(50))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClick(){
        clickCallback?()
    }
    
    @objc func buttonInClick(){
        btnInclickCallback?()
    }
}

