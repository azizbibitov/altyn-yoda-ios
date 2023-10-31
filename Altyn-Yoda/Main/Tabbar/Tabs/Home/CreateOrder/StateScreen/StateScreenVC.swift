//
//  StateScreenVC.swift
//  SalamExpress
//
//  Created by Aziz's MacBook Air on 27.03.2023.
//

import UIKit


class StateScreenVC: UIViewController {
    
    var mainView: StateScreenView {
        return view as! StateScreenView
    }
    
    override func loadView() {
        super.loadView()
        view = StateScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.successView.nextButton.clickCallback = { [weak self] in
           print("success")
            if let window = UIApplication.shared.windows.first {
                let vc = MainVC()
                window.rootViewController = UINavigationController(rootViewController:  vc)
                window.makeKeyAndVisible()
                UIView.transition(with: window, duration: 0.4, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            }
        }
        
    }


}
