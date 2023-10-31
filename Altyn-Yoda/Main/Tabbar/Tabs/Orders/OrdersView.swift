//
//  OrdersView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 04.04.2023.
//

import UIKit
import EasyPeasy

class OrdersView: UIView {
    
    lazy var noConnection = NoconnectionView()
    lazy var noContent = NoContent()
    lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.color = .primaryColor
        loading.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        return loading
    }()
    
    lazy var tableView: UITableView = {
        var tb = UITableView(frame: .zero, style: .plain)
        tb.register(OrderTableCell.self, forCellReuseIdentifier: OrderTableCell.identifier)
        tb.separatorStyle = .none
        tb.backgroundColor = .whiteBlackColor
        tb.allowsSelection = true
        tb.showsVerticalScrollIndicator = false
        tb.refreshControl = UIRefreshControl()
        return tb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteBlackColor
        
        setupUI()
    }
    
    func setupUI(){
        
        addSubview(tableView)
        tableView.easy.layout([
            Top(), Leading(), Trailing(), Bottom()
        ])
        
        addSubview(noConnection)
        noConnection.easy.layout(Edges())
        
        addSubview(noContent)
        noContent.easy.layout(Edges())
        
        addSubview(loading)
        loading.easy.layout([
            CenterX(), CenterY(-40), Size(80)
        ])
    }
    
    func showLoading(){
        loading.isHidden = false
        loading.startAnimating()
        noConnection.isHidden = true
        tableView.isHidden = true
        noContent.isHidden = true
    }
    
    func showNoConnection(){
        loading.isHidden = true
        loading.stopAnimating()
        noConnection.isHidden = false
        tableView.isHidden = true
        noContent.isHidden = true
    }
    
    func showNoContent(){
        loading.isHidden = true
        loading.stopAnimating()
        noConnection.isHidden = true
        tableView.isHidden = true
        noContent.isHidden = false
    }
    
    func showData(){
        loading.isHidden = true
        loading.stopAnimating()
        noConnection.isHidden = true
        tableView.isHidden = false
        noContent.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
