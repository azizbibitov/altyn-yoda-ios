//
//  MainChildTabBarController.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 04.04.2023.
//

import UIKit
import RxSwift

class MainChildTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    static let shared = MainChildTabBarController()
    var disposeBag = DisposeBag()
    static let changeLanguage: PublishSubject<Void> = PublishSubject<Void>.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabbar()
        setupVC()
        setupRx()
        
        self.delegate = self
    }
    
    func setupRx(){
        SettingsVC.shared.changeTheme.subscribe(onNext: { [weak self] isOn in
            if isOn{
                self?.makeTabItemsImagesDark()
            }else{
                self?.makeTabItemsImagesLight()
            }
        }).disposed(by: disposeBag)

        MainChildTabBarController.changeLanguage.subscribe { _ in
            self.langChanged()
        }.disposed(by: disposeBag)
    }
    
    func langChanged(){
        setupVC()
        print("RXXX")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupTabbar(){
        
        let backgroundColor = UIColor.tabBackColor
        let selectedItemTextColor = UIColor.black
        let unselectedItemTextColor = UIColor.white
        
        if #available(iOS 15, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = backgroundColor
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedItemTextColor]
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedItemTextColor]
            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        } else {
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: selectedItemTextColor], for: .selected)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: unselectedItemTextColor], for: .normal)
            tabBar.barTintColor = backgroundColor
        }
        
        tabBar.clipsToBounds = true
    }
    
    func setupVC() {
        let homeVC = HomeVC()
        homeVC.tabBarItem.tag = 1
        let calculatorVC = OrdersVC()
        calculatorVC.tabBarItem.tag = 2
        let profileVC = SettingsVC()
        profileVC.tabBarItem.tag = 3
        tabBar.tintColor = .textColor
        
        if ThemeUserDefaults.shared.theme == .light{
            homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "home-unselected")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "home-selected")?.withRenderingMode(.alwaysOriginal))
            
            calculatorVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "orders-unselected")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "orders-selected")?.withRenderingMode(.alwaysOriginal))
            
            profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "settings-unselected")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "settings-selected")?.withRenderingMode(.alwaysOriginal))
        }else{
            homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "home-unselected-dark")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "home-selected-dark")?.withRenderingMode(.alwaysOriginal))

            calculatorVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "orders-unselected-dark")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "orders-selected")?.withRenderingMode(.alwaysOriginal))

            profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "settings-unselected-dark")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "settings-selected")?.withRenderingMode(.alwaysOriginal))
        }
        
        
        self.viewControllers = [homeVC, calculatorVC, profileVC]
        
    }
    
    func makeTabItemsImagesDark(){
        self.tabBar.items?[0].image = UIImage(named: "home-unselected-dark")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[0].selectedImage = UIImage(named: "home-selected-dark")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].image = UIImage(named: "orders-unselected-dark")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].selectedImage = UIImage(named: "orders-selected")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].image = UIImage(named: "settings-unselected-dark")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].selectedImage = UIImage(named: "settings-selected")?.withRenderingMode(.alwaysOriginal)
    }
    
    func makeTabItemsImagesLight(){
        self.tabBar.items?[0].image = UIImage(named: "home-unselected")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[0].selectedImage = UIImage(named: "home-selected")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].image = UIImage(named: "orders-unselected")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].selectedImage = UIImage(named: "orders-selected")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].image = UIImage(named: "settings-unselected")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].selectedImage = UIImage(named: "settings-selected")?.withRenderingMode(.alwaysOriginal)
    }
    
    
    
//    func openArticle(){
//        let vc = ArticleVC()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
//    func openAllArticles(){
//        let vc = AllArticlesVC()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
//    func openSettings(){
//        let vc = SettingsVC()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
//    func openOrdersHistoryPage(){
//        let vc = OrderHistoryTableVC()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
}

