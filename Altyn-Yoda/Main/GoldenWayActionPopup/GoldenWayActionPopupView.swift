//
//  CustomActionPopupView.swift
//  MIU-LOVE
//
//  Created by Aziz's MacBook Air on 09.03.2023.
//

import UIKit
import EasyPeasy

class GoldenWayActionPopupView: UIView {

    let containerView = GoldenWayActionPopupContainerView()
    
    let actionLabel = GoldenWayLabel(font: .interMedium(size: 16), color: .textColor, numberOfLines: 0, text: "want_to_set_your_cridentials".localized())
    
    var btnsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 50
        return stack
    }()
    
    var yesBtn: ZFRippleButton = {
        let btn = ZFRippleButton()
        btn.setTitle("yes".localized(), for: .normal)
        btn.titleLabel?.font = .interSemiBold(size: 14)
        btn.backgroundColor = .primaryColor
        btn.layer.cornerRadius = 4
        btn.ripplePercent = 0.8
        btn.trackTouchLocation = true
        btn.rippleColor = .primaryColor!
        btn.rippleBackgroundColor = .white.withAlphaComponent(0.3)
        return btn
    }()
    
    var noBtn: ZFRippleButton = {
        let btn = ZFRippleButton()
        btn.setTitle("no".localized(), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .interRegular(size: 14)
        btn.backgroundColor = .noActionPopupColor
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.textColor?.cgColor
        btn.ripplePercent = 0.8
        btn.trackTouchLocation = true
        btn.rippleColor = .hoverColor!
        btn.rippleBackgroundColor = .white.withAlphaComponent(0.3)
        return btn
    }()
    
    var yesActionCallback: ( ()->Void )?
    var noActionCallback: ( ()->Void )?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        addTargets()
    }
    
    func addTargets(){
        yesBtn.addTarget(self, action: #selector(yesActionTap), for: .touchUpInside)
        noBtn.addTarget(self, action: #selector(noActionTap), for: .touchUpInside)
    }
    
    func setupUI(){
        
        backgroundColor = UIColor.black.withAlphaComponent(0.50)
        addSubview(containerView)
        containerView.easy.layout([
            Height(140), Leading(16), Trailing(16), CenterY(-40)
        ])
        
        containerView.addSubview(actionLabel)
        actionLabel.easy.layout([
            Top(24), Leading(24), Trailing(24)
        ])
        
        containerView.addSubview(btnsStack)
        btnsStack.easy.layout([
            Top(24).to(actionLabel, .bottom), CenterX(), Height(30)
        ])
        
        btnsStack.addArrangedSubview(yesBtn)
        btnsStack.addArrangedSubview(noBtn)
        
        yesBtn.easy.layout(Width(90))
        noBtn.easy.layout(Width(90))
        
    }
    
    @objc func yesActionTap() {
        yesActionCallback?()
    }
    
    
    @objc func noActionTap() {
        noActionCallback?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
