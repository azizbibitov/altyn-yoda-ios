//
//  ChoiceViewWithTopLbl.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 08.04.2023.
//

import UIKit

class ChoiceViewWithTopLbl: UIStackView {
    
    var label = UILabel(font: .interMedium(size: 14))
    var choiceView = ChoiceView()
    
    init(lbl: String, yesChoiceLblText: String, noChoiceLblText: String){
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = 4
        self.alignment = .fill
        self.addArrangedSubview(label)
        self.addArrangedSubview(choiceView)
        label.text = lbl
        choiceView.yesBtn.setTitle(yesChoiceLblText, for: .normal)
        choiceView.noBtn.setTitle(noChoiceLblText, for: .normal)
    }
    
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
