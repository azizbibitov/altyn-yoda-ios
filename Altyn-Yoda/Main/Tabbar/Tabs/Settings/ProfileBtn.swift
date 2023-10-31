//
//  ProfileBtn.swift
//  SalamExpress
//
//  Created by Aziz's MacBook Air on 15.02.2023.
//

import UIKit
import EasyPeasy

class ProfileBtn: ZFRippleButton {
    
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .interMedium(size: 16)
        lbl.textColor = .textColor
        lbl.text = "Profile"
        return lbl
    }()
    
    var phoneNumberLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .textColor
        lbl.font = .interRegular(size: 12)
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.text = "+993 12 13 14 15"
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
        layer.cornerRadius = 10
        rippleColor = .hoverColor!
        rippleBackgroundColor = .customBtnBack!
        ripplePercent = 3.0
        trackTouchLocation = true
        setupViews()
    }
    
    func setupViews(){
        addSubview(nameLabel)
        nameLabel.easy.layout([
            Leading(10), Top(10)
        ])
        
        addSubview(phoneNumberLabel)
        phoneNumberLabel.easy.layout([
            Top(5).to(nameLabel, .bottom), Leading().to(nameLabel, .leading)
        ])
        
        
        addSubview(rightIcon)
        rightIcon.easy.layout([
            Trailing(10), CenterY()
        ])
        
      
    }
    
    func setupProfile(name: String, phoneNumber: String){
        nameLabel.text = name
        phoneNumberLabel.text = phoneNumber
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

