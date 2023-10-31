//
//  CustomButton.swift
//  SalamExpress
//
//  Created by Parahat Caryyew on 12.02.2023.
//

import UIKit
import EasyPeasy

class Button: UIButton {

    lazy var clickCallback: ( ()->() )? = nil
    
    init(title: String, fsize: CGFloat = 16){
        super.init(frame: .zero)
        
        self.titleLabel?.font = .interMedium(size: fsize)
        self.backgroundColor = .clear
        self.setTitleColor(.textColor, for: .normal)
        self.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 22
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(named: "textColor")?.cgColor
        self.easy.layout(Height(44))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func blackColor(){
        isEnabled = true
        setTitleColor(.white, for: .normal)
        backgroundColor = .btnBlackYellowColor
        layer.borderWidth = 0.0
    }
    
    func whiteColor(){
        isEnabled = true
        setTitleColor(.textColor, for: .normal)
        layer.borderColor = UIColor(named: "textColor")?.cgColor
        backgroundColor = .white
    }
    
    func disabled(){
        isEnabled = false
        setTitleColor(.textColor, for: .normal)
        layer.borderColor = UIColor(named: "textColor")?.cgColor
        layer.borderWidth = 1.0
        backgroundColor = .clear
    }
    
    func fill(){
        isEnabled = true
        layer.borderColor = UIColor(named: "primaryColor")?.cgColor
        backgroundColor = .primaryColor
        setTitleColor(.white, for: .normal)
    }
    
    func error(){
        isEnabled = false
        layer.borderColor = UIColor(named: "errorColor")?.cgColor
        backgroundColor = .errorColor
        setTitleColor(.white, for: .normal)
    }
    
    func errorColor(){
        isEnabled = true
        layer.borderColor = UIColor(hexString: "#FF0000").cgColor
        backgroundColor = UIColor(hexString: "#FF0000")
        setTitleColor(.white, for: .normal)
    }
    
    @objc func buttonClick(){
        clickCallback?()
    }
}
