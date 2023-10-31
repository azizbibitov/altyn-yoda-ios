//
//  NotificationButton.swift
//  SalamExpress
//
//  Created by Aziz's MacBook Air on 12.02.2023.
//

import UIKit
import EasyPeasy

class CustomButton: ZFRippleButton {
    
    var imageName: String = ""
    var withBlueCircle: Bool = false
    var cornerRadius: CGFloat = 0
    var withOriginalImage: Bool = false
    var withBackgroundColor: Bool = false
    
    var btnInImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    var btnInIcon: UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = false
        btn.tintColor = .textColor
        return btn
    }()
    
    lazy var blueCircleBorder: UIView = {
        let vw = UIView()
        vw.backgroundColor = .customBtnBack
        vw.layer.cornerRadius = 6
        vw.easy.layout(Size(12))
        return vw
    }()
    
    lazy var blueCircle: UIView = {
        let vw = UIView()
        vw.backgroundColor = .primaryColor
        vw.layer.cornerRadius = 7/2
        vw.easy.layout(Size(7))
        return vw
    }()
    
    init(imageName: String, withBlueCircle: Bool = false, cornerRadius: CGFloat = 6, withOriginalImage: Bool = true, withBackgroundColor: Bool = false) {
        super.init(frame: .zero)
        self.imageName = imageName
        self.withBlueCircle = withBlueCircle
        self.cornerRadius = cornerRadius
        self.withOriginalImage = withOriginalImage
        self.withBackgroundColor = withBackgroundColor
        configure()
    }
    
    func configure(){
       
        layer.cornerRadius = cornerRadius
        rippleColor = .hoverColor!
        rippleBackgroundColor = .customBtnBack!
        ripplePercent = 3.0
        trackTouchLocation = true
        if withOriginalImage{
            addBtnInImage()
            
        }else{
            addBtnInIcon()
        }
        
        if withBackgroundColor {
            backgroundColor = .backgroundColor
        }
       
    }
    
    func addBtnInImage(){
        btnInImage.image = UIImage(named: imageName)
        addSubview(btnInImage)
        btnInImage.easy.layout(Center())
        
        if withBlueCircle {
            addBlueCircle()
        }
    }
    
    func addBtnInIcon(){
        btnInIcon.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        addSubview(btnInIcon)
        btnInIcon.easy.layout(Center())
        
        if withBlueCircle {
            addBlueCircleToTemplateImage()
        }
    }
    
    func addBlueCircle(){
        addSubview(blueCircle)
        blueCircleBorder.isHidden = true
        blueCircleBorder.easy.layout([
            Trailing(-4.5).to(btnInImage, .trailing), Top(-2.5).to(btnInImage, .top)
        ])
        
        blueCircleBorder.addSubview(blueCircle)
        blueCircle.easy.layout([
            Center()
        ])
    }
    
    func addBlueCircleToTemplateImage(){
        addSubview(blueCircleBorder)
        blueCircleBorder.isHidden = true
        blueCircleBorder.easy.layout([
            Trailing(-4.5).to(btnInIcon, .trailing), Top(-2.5).to(btnInIcon, .top)
        ])
        
        blueCircleBorder.addSubview(blueCircle)
        blueCircle.easy.layout([
            Center()
        ])
    }
    
    
    
    
    func toggleNotifications(_ bool: Bool){
        print("toggleNotifications")
        bool ? (blueCircleBorder.isHidden = false) : (blueCircleBorder.isHidden = true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
