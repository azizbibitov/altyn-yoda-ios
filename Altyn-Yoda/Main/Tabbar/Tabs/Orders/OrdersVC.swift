//
//  OrdersVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 04.04.2023.
//

import UIKit
import RxSwift

class OrdersVC: UIViewController {
    
    var orders: [Order] = []
    var lastPage: Bool = false
    lazy var disposeBag = DisposeBag()
    
    var mainView: OrdersView {
        return view as! OrdersView
    }
    
    override func loadView() {
        super.loadView()
        view = OrdersView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAllOrders(model: GetAllOrdersBody(uuid: AccountUserDefaults.shared.getUser().uuid, status: 0, createdAt: "0"))
        mainView.showLoading()
        lastPage = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallbacks()
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        
        mainView.tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        getAllOrders(model: GetAllOrdersBody(uuid: AccountUserDefaults.shared.getUser().uuid, status: 0, createdAt: "0"))
        self.mainView.tableView.refreshControl?.endRefreshing()
        lastPage = false
    }
    
    func setupCallbacks() {
        mainView.noConnection.clickCallback = { [weak self] in
            self!.mainView.showLoading()
            self!.getAllOrders(model: GetAllOrdersBody(uuid: AccountUserDefaults.shared.getUser().uuid, status: 0, createdAt: "0"))
        }
    }
    
}

extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableCell.identifier, for: indexPath) as! OrderTableCell
        cell.setupCellData(orders[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = orders.count
        if indexPath.row == count && !lastPage {
            getAllOrders(model: GetAllOrdersBody(uuid: AccountUserDefaults.shared.getUser().uuid, status: 0, createdAt: orders[indexPath.row].created_at ?? ""))
            let spinner = UIActivityIndicatorView()
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = lastPage
        }else{
            tableView.tableFooterView?.isHidden = lastPage
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? OrderTableCell {
            UIView.animate(withDuration: 0.3, animations: {
                cell.contentLayer.backgroundColor = .hoverColor
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.contentLayer.backgroundColor = .backgroundColor
                    })
                }
            })
        }
        let vc = OrderPageVC()
        vc.orderID = orders[indexPath.row].uuid ?? ""
        vc.order = orders[indexPath.row]
        vc.serviceID = orders[indexPath.row].service_id ?? ""
        vc.rateID = orders[indexPath.row].rate_id
        self.navigationController?.pushViewController(vc, animated: true)
        print("\(indexPath.row)")
    }
    
}

extension OrdersVC {
    func getAllOrders(model: GetAllOrdersBody){
        OrderRequests.shared.getAllOrders(model: model).subscribe { resp in
            if model.createdAt == "0"  && resp.data == nil {
                self.orders = []
                self.mainView.tableView.reloadData()
                self.mainView.showNoContent()
                self.lastPage = true
            } else if resp.data == nil {
                self.lastPage = true
            } else {
                self.orders = model.createdAt == "0" ? [] : self.orders
                self.orders.append(contentsOf: resp.data ?? [])
                self.mainView.showData()
                self.mainView.tableView.reloadData()
            }
        } onFailure: { _ in
            self.mainView.showNoConnection()
        }.disposed(by: disposeBag)
    }
}
