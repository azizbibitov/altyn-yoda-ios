//
//  File.swift
//  SalamExpress
//
//  Created by Aziz's MacBook Air on 17.03.2023.
//

import UIKit
import EasyPeasy

class LanguageCell: UITableViewCell {
    
    lazy var wrapper = UIView()
    
    lazy var title: UILabel = {
        var lbl = UILabel()
        lbl.font = .interRegular(size: 14)
        lbl.textColor = .textColor
        lbl.sizeToFit()
        lbl.setContentHuggingPriority(.required, for: .horizontal)
        return lbl
    }()
    
 
    
    lazy var radioBtn = RadioBtnLanguage()
    
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(wrapper)
        wrapper.backgroundColor = .whiteBlackColor

        wrapper.addSubview(title)
        title.easy.layout([
            Top(), Bottom(), Leading(20)
        ])
        
        wrapper.easy.layout([
            Leading(), Trailing(), Bottom(), Height(50)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configureCellWithRadioBtn(name: String, isSelected: Bool) {
        wrapper.easy.layout(Top())

        wrapper.addSubview(radioBtn)
        radioBtn.easy.layout([
            CenterY(), Trailing(20),
        ])
          
        title.text = name
        radioBtn.setState(isSelected: isSelected)
    }
    
    
}

