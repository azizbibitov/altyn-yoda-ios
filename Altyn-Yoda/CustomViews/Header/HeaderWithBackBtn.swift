//
//  HeaderWithBackBtn.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 14.02.2023.
//

import UIKit
import EasyPeasy

class HeaderWithBackBtn: UIView {
    
    var title: String = ""
    var btnImage: String = ""
    var withBtn: Bool = false
    var withOriginalImage: Bool = false

    var header: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var backBtn: CustomButton = {
        let btn = CustomButton(imageName: "arrow-left", cornerRadius: 6, withOriginalImage: false)
        btn.backgroundColor = .backgroundColor
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .interMedium(size: 16)
        lbl.textColor = .textColor
        lbl.textAlignment = .center
        return lbl
    }()
    
    var customBtn: CustomButton!
    
    var customBtnClickCallback: ( ()-> Void )?
    var backBtnClickCallback: ( ()-> Void )?

    init(title: String = "", withBtn: Bool = false, btnImage: String = "", withOriginalImage: Bool = false) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.withBtn = withBtn
        self.btnImage = btnImage
        self.withOriginalImage = withOriginalImage
        
        if self.withBtn {
            if withOriginalImage{
                customBtn = CustomButton(imageName: btnImage, withBlueCircle: true, withOriginalImage: true, withBackgroundColor: true)
            }else{
                customBtn = CustomButton(imageName: btnImage, withBlueCircle: true, withOriginalImage: false, withBackgroundColor: true)
            }
            
            customBtn.isUserInteractionEnabled = true
            customBtn.addTarget(self, action: #selector(btnTap), for: .touchUpInside)
        }
        
        backBtn.addTarget(self, action: #selector(backBtnTap), for: .touchUpInside)
        setupHeader()

    }

    func setupHeader() {

        addSubview(header)
        header.easy.layout([
            Edges(), Height(60)
        ])
        
        header.addSubview(backBtn)
        backBtn.easy.layout([
            CenterY(), Leading(20), Size(35)
        ])
        
        header.addSubview(titleLabel)
        titleLabel.easy.layout([
            Leading(50),
            CenterY().to(backBtn, .centerY),
            Trailing(50)
        ])
        
        if self.withBtn {
            header.addSubview(customBtn)
            customBtn.easy.layout([
                CenterY(), Trailing(20), Size(40)
            ])
        }
      


    }


    @objc func btnTap() {
        customBtnClickCallback?()
    }
    
    @objc func backBtnTap() {
        backBtnClickCallback?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

