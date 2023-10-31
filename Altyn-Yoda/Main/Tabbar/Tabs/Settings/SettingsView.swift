//
//  SettingsView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 04.04.2023.
//

import UIKit
import EasyPeasy

class SettingsView: UIView {
    
    lazy var tableView: UITableView = {
        var tb: UITableView!
        if #available(iOS 13.0, *) {
            tb = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            tb = UITableView(frame: .zero, style: .grouped)
        }
        tb.register(SettingsTableCell.self, forCellReuseIdentifier: SettingsTableCell.identifier)
        tb.register(SettingTableHeader.self, forHeaderFooterViewReuseIdentifier: SettingTableHeader.identifier)
        tb.separatorStyle = .none
        tb.backgroundColor = .whiteBlackColor
        tb.allowsSelection = false
        tb.showsVerticalScrollIndicator = false
        return tb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteBlackColor
        setupUI()
        
    }
    
    func setupUI() {
        
        addSubview(tableView)
        tableView.easy.layout(Leading(), Trailing(), Top(), Bottom().to(safeAreaLayoutGuide, .bottom))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
