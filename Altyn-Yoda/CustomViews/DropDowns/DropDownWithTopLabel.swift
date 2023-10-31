//
//  DropDownWithTopLabel.swift
//  MIU-LOVE
//
//  Created by Aziz's MacBook Air on 19.02.2023.
//

import UIKit
import EasyPeasy

class DropDownWithTopLabel: UIStackView {
    
    var label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.textColor
        lbl.font = .interMedium(size: 12)
        return lbl
    }()
    
    var dropBtn = ButtonWithIcon(title: "", icon: "arrow-down")
    
    init(lbl: String = "", pl: String = ""){
        super.init(frame: .zero)
        axis = .vertical
        alignment = .fill
        spacing = 6
        
        label.text = lbl
        dropBtn.easy.layout(Height(50))
        dropBtn.setTitle(pl, for: .normal)
        
        addArrangedSubview(label)
        addArrangedSubview(dropBtn)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
