//
//  DropDownTableCell.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 09.04.2023.
//

import UIKit
import EasyPeasy

class DropDownTableCell: UITableViewCell {
    
    static let identifier = String(describing: DropDownTableCell.self)
    
    var lbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .textColor
        lbl.font = .interRegular(size: 14)
        return lbl
    }()
    
    var clickCallback: ( ()->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lbl)
        lbl.easy.layout(Leading(10), CenterY())
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
    }
    
    @objc func click(){
        clickCallback?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
