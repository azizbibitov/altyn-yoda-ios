//
//  SettingTableHeader.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 05.04.2023.
//

import UIKit
import EasyPeasy

class SettingTableHeader: UITableViewHeaderFooterView {
    
    static let identifier = String(describing: SettingTableHeader.self)

    let profileBtn = ProfileBtn()
    
    var goProfileClickCallback: ( ()-> Void )?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addTargets()
        setupTableHeader()
        
    }
    
  
    func addTargets(){
        profileBtn.addTarget(self, action: #selector(goProfileClick), for: .touchUpInside)
    }
    
    func setupTableHeader(){
        contentView.addSubview(profileBtn)
        profileBtn.easy.layout([
            Leading(), Trailing(), Top(20), Bottom(20), Height(60)
        ])
        
    }
    
    @objc func goProfileClick(){
        goProfileClickCallback?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
