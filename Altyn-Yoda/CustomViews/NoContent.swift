//
//  NoContent.swift
//  SalamExpress
//
//  Created by Parahat Caryyew on 13.03.2023.
//

import UIKit
import EasyPeasy

class NoContent: UIView {
    
    var wrapper = UIView()
    var cloudImage = UIImageView(name: "forbidden", size: 40)
    var title = UILabel(text: "no_content".localized(), font: .interMedium(size: 18), color: .textColor!, align: .center)
    var nextButton = Button(title: "next".localized(), fsize: 18)
    
    lazy var clickCallback: ( ()->() )? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nextButton.fill()
        cloudImage.image = UIImage(named: "forbidden")?.withRenderingMode(.alwaysTemplate)
        cloudImage.tintColor = .textColor
        setupUI()
    }
    
    func setupUI(){
        self.addSubview(wrapper)
        wrapper.easy.layout([
            Leading(>=50),
            Trailing(>=50),
            Width(<=300),
            CenterX(),
            CenterY()
        ])
        wrapper.addSubview(cloudImage)
        cloudImage.easy.layout([
            Top(),
            CenterX()
        ])
        wrapper.addSubview(title)
        title.easy.layout([
            Top(20).to(cloudImage, .bottom),
            Leading(),
            Trailing()
        ])
        wrapper.addSubview(nextButton)
        nextButton.easy.layout([
            Top(20).to(title, .bottom),
            CenterX(),
            Bottom(),
            Height(44),
            Width(150)
        ])
        nextButton.isHidden = true
    }
    
    @objc func btnTapped(){
        clickCallback?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
