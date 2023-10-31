//
//  TechInspectionView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 08.04.2023.
//

import UIKit
import EasyPeasy

class TechInspectionView: UIView {
    
    var horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.spacing = 20
        return stack
    }()
    
    var techInspectionDate: DateTextFieldWithTopLabel = {
       let field = DateTextFieldWithTopLabel(lbl: "tech_inspection_date".localized(), pl: "01/02/2022".localized(), icon: "date-icon")
        field.isTimePicker = false
        return field
    }()
    
    var techInspectionHour: DateTextFieldWithTopLabel = {
       let field = DateTextFieldWithTopLabel(lbl: "tech_inspection_hour".localized(), pl: "14:30".localized(), icon: "clock")
        field.isTimePicker = true
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(horizontalStack)
        horizontalStack.easy.layout([
            Edges(), Height(70)
        ])
        
        horizontalStack.addArrangedSubview(techInspectionDate)
        horizontalStack.addArrangedSubview(techInspectionHour)
        
        
        techInspectionDate.setupWithDatePicker(isTimePicker: false)
        techInspectionHour.setupWithDatePicker(isTimePicker: true)
        
        techInspectionDate.doneClickedCallBack = { [weak self] in
            print("doneClickedCallBackDate")
//            self?.checkUpData()
        }
        
        techInspectionHour.doneClickedCallBack = { [weak self] in
            print("doneClickedCallBackHour")
//            self?.checkUpData()
        }
        
        techInspectionHour.easy.layout([Width(DeviceDimensions.shared.screenWidth()*0.32)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
