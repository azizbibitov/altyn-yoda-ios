//
//  ButtonWithIcon.swift
//  SalamExpress
//
//  Created by Parahat Caryyew on 12.02.2023.
//

import UIKit
import EasyPeasy

class ButtonWithIcon: UIButton {

    lazy var clickCallback: ( ()->() )? = nil
    
    init(title: String, fsize: CGFloat = 14, icon: String = "arrow-right"){
        super.init(frame: .zero)
        
        self.titleLabel?.easy.layout([ Leading(10),Width().like(self),  CenterY() ])
        self.imageView?.easy.layout([ Leading(4).to(self.titleLabel!, .trailing), Trailing(10), CenterY() ])
        
        
        self.setImage(UIImage(named: icon)?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.tintColor = .textColor!
        self.titleLabel?.font = .interRegular(size: fsize)
        self.setTitleColor(.textColor, for: .normal)
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(named: "textColor")?.cgColor
        self.easy.layout(Height(45))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClick(){
        clickCallback?()
    }
}
