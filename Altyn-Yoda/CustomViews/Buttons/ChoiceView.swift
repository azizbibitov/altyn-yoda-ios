//
//  ChoiceView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 08.04.2023.
//

import UIKit
import EasyPeasy

class ChoiceView: UIView {
    
    var choice: Int = 0
    var calculatePriceDelegate: PackageChoiceProtocol?
    
    var horizontalStack: UIStackView = {
        let stack = UIStackView()
//        stack.spacing = 35
        stack.distribution = .fill
        return stack
    }()
    
    var spacer = UIView(frame: .zero)
    
    var yesBtn: ZFRippleButton = {
        let btn = ZFRippleButton()
        btn.setTitle("yawdawdes".localized(), for: .normal)
        btn.titleLabel?.font = .interRegular(size: 14)
        
        btn.setImage(UIImage(named: "radio_button_unchecked")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setImage(UIImage(named: "radio_button_unchecked")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        btn.imageView?.easy.layout(Trailing(7).to(btn.titleLabel!, .leading))
        btn.titleLabel?.easy.layout(CenterX(10))
        
        btn.ripplePercent = 0.8
        btn.trackTouchLocation = true
        btn.rippleColor = .blackBtnHover!
        btn.rippleBackgroundColor = .whiteBlackForBtn!
        btn.layer.cornerRadius = 6
        btn.layer.borderColor = UIColor.textColor?.cgColor
        btn.layer.borderWidth = 1
        
        
        btn.backgroundColor = .whiteBlackColor
        btn.tintColor = .textColor
        btn.setTitleColor(.textColor, for: .normal)
        
        return btn
    }()
    
    var noBtn: ZFRippleButton = {
        let btn = ZFRippleButton()
        btn.setTitle("no".localized(), for: .normal)
        btn.titleLabel?.font = .interRegular(size: 14)
        
        btn.setImage(UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setImage(UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        
        btn.imageView?.easy.layout(Trailing(7).to(btn.titleLabel!, .leading))
        btn.titleLabel?.easy.layout(CenterX(10))
        
        btn.ripplePercent = 0.8
        btn.trackTouchLocation = true
        btn.rippleColor = .blackBtnHover!
        btn.rippleBackgroundColor = .whiteBlackForBtn!
        btn.layer.cornerRadius = 6
        btn.layer.borderColor = UIColor.textColor?.cgColor
        btn.layer.borderWidth = 0
        
        
        btn.backgroundColor = .btnBlackYellowColor
        btn.tintColor = .white
        btn.setTitleColor(.white, for: .normal)
        
        return btn
    }()
    
    var yesClickCallback: ( ()-> Void )?
    var noClickCallback: ( ()-> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        
        setupViews()
        
        addTargets()
        

    }
    
    func configureView(){
        self.easy.layout(Height(40))
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.textColor?.cgColor
    }
    
    func setupViews(){
        addSubview(horizontalStack)
        horizontalStack.easy.layout([
            Edges(5)
        ])
        
        horizontalStack.addArrangedSubview(noBtn)
        horizontalStack.addArrangedSubview(spacer)
        horizontalStack.addArrangedSubview(yesBtn)
        
        noBtn.easy.layout(Width(140))
        yesBtn.easy.layout(Width(140))
    }
    
    func addTargets(){
        yesBtn.addTarget(self, action: #selector(yesClick), for: .touchUpInside)
        noBtn.addTarget(self, action: #selector(noClick), for: .touchUpInside)
    }
    
    func choseYes(){
        yesBtn.backgroundColor = .btnBlackYellowColor
        yesBtn.tintColor = .white
        yesBtn.setImage(UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate), for: .normal)
        yesBtn.setImage(UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        yesBtn.setTitleColor(.white, for: .normal)
        yesBtn.layer.borderWidth = 0
        
        noBtn.backgroundColor = .whiteBlackColor
        noBtn.tintColor = .textColor
        noBtn.setImage(UIImage(named: "radio_button_unchecked")?.withRenderingMode(.alwaysTemplate), for: .normal)
        noBtn.setImage(UIImage(named: "radio_button_unchecked")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        noBtn.setTitleColor(.textColor, for: .normal)
        noBtn.layer.borderWidth = 1
    }
    
    func choseNo(){
        noBtn.backgroundColor = .btnBlackYellowColor
        noBtn.tintColor = .white
        noBtn.setImage(UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate), for: .normal)
        noBtn.setImage(UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        noBtn.setTitleColor(.white, for: .normal)
        noBtn.layer.borderWidth = 0
        
        yesBtn.backgroundColor = .whiteBlackColor
        yesBtn.tintColor = .textColor
        yesBtn.setImage(UIImage(named: "radio_button_unchecked")?.withRenderingMode(.alwaysTemplate), for: .normal)
        yesBtn.setImage(UIImage(named: "radio_button_unchecked")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        yesBtn.setTitleColor(.textColor, for: .normal)
        yesBtn.layer.borderWidth = 1
    }
    
    @objc func yesClick(){
        yesClickCallback?()
        choseYes()
        choice = 1
        calculatePriceDelegate?.calculatePrice()
    }
    
    @objc func noClick(){
        noClickCallback?()
        choseNo()
        choice = 0
        calculatePriceDelegate?.calculatePrice()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
