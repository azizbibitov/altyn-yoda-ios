//
//  ProfileBtn.swift
//  SalamExpress
//
//  Created by Aziz's MacBook Air on 15.02.2023.
//

import UIKit
import EasyPeasy

class SettingTableHeaderBtn: ZFRippleButton {
    
    lazy var emailLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .interMedium(size: 16)
        lbl.textColor = .textColor
        lbl.text = "info@altynyoda.com"
        return lbl
    }()
   
    lazy var rightIcon: UIImageView = {
        var img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "right")!.withRenderingMode(.alwaysTemplate)
        img.tintColor = .textColor!
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func configure(){
        backgroundColor = .backgroundColor
        layer.cornerRadius = 6
        rippleColor = .hoverColor!
        rippleBackgroundColor = .customBtnBack!
        ripplePercent = 3.0
        trackTouchLocation = true
        setupViews()
    }
    
    func setupViews(){
        addSubview(emailLabel)
        emailLabel.easy.layout([
            Leading(15), Top(20), Bottom(20)
        ])
        
        addSubview(rightIcon)
        rightIcon.easy.layout([
            Trailing(10), CenterY()
        ])
        
    }
    
    func setupProfile(name: String, phoneNumber: String){
//        nameLabel.text = name
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

