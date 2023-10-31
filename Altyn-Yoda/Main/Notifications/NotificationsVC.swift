//
//  NotificationsVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 22.04.2023.
//

import UIKit
import RxSwift

class NotificationsVC: UIViewController {
    
    var notifications: [NotificationModel] = []
    var lastPage: Bool = false
    lazy var disposeBag = DisposeBag()
    
    var mainView: NotificationsView {
        return view as! NotificationsView
    }
    
    override func loadView() {
        super.loadView()
        view = NotificationsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallbacks()
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        
        getAllNotifications(createdAt: "0")
        mainView.showLoading()
        mainView.tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        mainView.tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    @objc func handleRefreshControl() {
        self.getAllNotifications(createdAt: "0")
        self.mainView.tableView.refreshControl?.endRefreshing()
        lastPage = false
    }
    
    func setupCallbacks() {
        mainView.noConnection.clickCallback = { [weak self] in
            self!.mainView.showLoading()
            self!.getAllNotifications(createdAt: "0")
        }
        
        mainView.header.backBtnClickCallback = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                   return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
                   return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableCell.identifier, for: indexPath) as! NotificationTableCell
        cell.setupCellData(notifications[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = notifications.count
        if indexPath.row == count && !lastPage {
            getAllNotifications(createdAt: notifications[indexPath.row].createdAt ?? "")
            let spinner = UIActivityIndicatorView()
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = lastPage
        }else{
            tableView.tableFooterView?.isHidden = lastPage
        }
    }
    
    
}

extension NotificationsVC {
    func getAllNotifications(createdAt: String){
        HomeRequests.shared.getAllNotifications(createdAt: createdAt).subscribe { resp in
            if createdAt == "0"  && resp.data == nil {
                self.notifications = []
                self.mainView.tableView.reloadData()
                self.mainView.showNoContent()
                self.lastPage = true
            } else if resp.data == nil {
                self.lastPage = true
            } else {
                self.notifications = createdAt == "0" ? [] : self.notifications
                self.notifications.append(contentsOf: resp.data ?? [])
                self.mainView.showData()
                self.mainView.tableView.reloadData()
            }
            MainVC.shared.notificationArrived.accept((false))
        } onFailure: { _ in
            self.mainView.showNoConnection()
        }.disposed(by: disposeBag)
    }
}

