//
//  AddPhotoCollectionCell.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 09.04.2023.
//

import UIKit
import EasyPeasy
import Kingfisher

class AddPhotoCollectionCell: UICollectionViewCell {
    
    static let identifier = String(describing: AddPhotoCollectionCell.self)
    
    var clickLayer: ZFRippleButton = {
       let btn = ZFRippleButton()
        btn.backgroundColor = .whiteBlackColor
        btn.ripplePercent = 2
        btn.trackTouchLocation = true
        btn.rippleColor = .hoverColor!
        btn.rippleBackgroundColor = .white.withAlphaComponent(0.3)
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        btn.setImage(UIImage(named: "add-photo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .textColor
        btn.imageView?.easy.layout(Center(), Height(50), Width(60))
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    var clickCallback: ( ()-> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .whiteBlackColor
        contentView.layer.cornerRadius = 6
        contentView.easy.layout([
            Width(105), Height(105)
        ])
        
        contentView.addSubview(clickLayer)
        clickLayer.easy.layout([
            Edges()
        ])
        clickLayer.layer.cornerRadius = 6
    }
   
    
    @objc func click() {
        clickCallback?()
    }
    
    func showItsEmpty(){
        contentView.layer.borderColor = UIColor.errorColor?.cgColor
        contentView.layer.borderWidth = 1
    }
    
    func showItsNotEmpty(){
        contentView.layer.borderWidth = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

