//
//  EmptyTableHeader.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 05.04.2023.
//

import UIKit
import EasyPeasy

class EmptyTableHeader: UITableViewHeaderFooterView {
    
    static let identifier = String(describing: EmptyTableHeader.self)
    
    let headerLayer = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupTableHeader()
    }
    
    
    func setupTableHeader(){
        contentView.addSubview(headerLayer)
        headerLayer.easy.layout(Edges())
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
