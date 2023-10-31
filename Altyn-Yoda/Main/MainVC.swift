//
//  MainVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 04.04.2023.
//

import UIKit
import EasyPeasy
import RxSwift
import RxRelay

class MainVC: UIViewController {
    
    static let shared = MainVC()
    var notificationArrived: PublishRelay<Bool> = PublishRelay<Bool>.init()
    let tabBarVC = MainChildTabBarController()
    var disposeBag = DisposeBag()
    var bool = false
    
    var mainView: MainView {
        return view as! MainView
    }
    
    override func loadView() {
        super.loadView()
        view = MainView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.statusBarColorChange()
//        setNeedsStatusBarAppearanceUpdate()
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if #available(iOS 13.0, *) {
//            return .darkContent
//        } else {
//            return .default
//        }
//
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTabBarChildVC()
        setupCallbacks()
        
        setupRx()
    }
    
    func setupRx(){
        MainVC.shared.notificationArrived.subscribe(onNext: { [weak self] isOn in
            print("setupRxnotificationArrived")
            self?.mainView.header.notificationsBtn.toggleNotifications(isOn)
        }).disposed(by: disposeBag)
//
//
//        SettingsVC.shared.changeTheme.subscribe(onNext: { [weak self] isOn in
//            if isOn{
//                self?.mainView.header.salamExpressLogo.image = UIImage(named: "salam-express-logo-dark")
//            }else{
//                self?.mainView.header.salamExpressLogo.image = UIImage(named: "salam-express-logo")
//            }
//        }).disposed(by: disposeBag)
    }
    
    func setupCallbacks() {
        mainView.header.notificationsClickCallback = { [weak self] in
            print("notificationsClick")
            self?.navigationController?.pushViewController(NotificationsVC(), animated: true)
        }
    }
    
    func addTabBarChildVC(){
        self.mainView.tabBarContainerView.addSubview(tabBarVC.view)
        self.addChild(tabBarVC)
        tabBarVC.didMove(toParent: self)
        tabBarVC.view.easy.layout([
           Edges()
        ])
    }


}

