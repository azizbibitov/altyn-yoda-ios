//
//  EnterCodeVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 03.04.2023.
//

import UIKit
import RxSwift

class EnterCodeVC: UIViewController {
    
    var phoneText = ""
    var phone = ""
    lazy var disposeBag = DisposeBag()
    
    var mainView: EnterCodeView {
        return view as! EnterCodeView
    }
    
    override func loadView() {
        super.loadView()
        view = EnterCodeView()
        view.backgroundColor = .backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.subtitle.text?.append(contentsOf: phoneText)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = true
        
        setupCallBacks()
    }
    
    func setupCallBacks(){
        mainView.codeTextField.didReceiveCode = { [weak self] code in
            self?.checkSMS(code: Int(code) ?? 0)
        }
        
        mainView.codeTextField.notFilled = { [weak self] in
//            self?.mainView.applyCodeStatus(.notFilled)
        }
        
        mainView.changeNumberBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.resendClickCallback = { [weak self] in
            self!.sendSms(phone: String(self!.phone.dropFirst(4)))
        }
        
    }
    
    
}


// MARK: API REQUESTS

extension EnterCodeVC {
    
    func checkSMS(code: Int){
        mainView.loading.startAnimating()
        AuthRequests.shared.checkClient(phone: self.phone, code: code).subscribe { res in
            self.mainView.loading.stopAnimating()
            //            self.mainView.applyCodeStatus(.right)
            if res.data == nil {
                let vc = RegistrationVC()
                vc.phone = self.phone
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                AccountUserDefaults.shared.saveUser(accountUserDefaultsModel: AccountUserDefaultsModel(uuid: res.data?.uuid ?? "", username: res.data?.name ?? "", phone: res.data?.phoneNumber ?? "", address: res.data?.address ?? "", location: res.data?.location ?? "", token: res.data?.token ?? ""))
                
                if let window = UIApplication.shared.windows.first {
                    AccountUserDefaults.shared.userLogin()
                    let vc = MainVC()
                    window.rootViewController = UINavigationController(rootViewController:  vc)
                    window.makeKeyAndVisible()
                    UIView.transition(with: window, duration: 0.4, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                }
            }
            
        } onFailure: { _ in
            print("Failure")
            self.mainView.loading.stopAnimating()
            //            self.mainView.applyCodeStatus(.wrong)
            self.mainView.codeView.shake()
            SoundPlayer.shared.vibrate()
        }.disposed(by: disposeBag)
    }
        
        func sendSms(phone: String) {
            mainView.loading.startAnimating()
            AuthRequests.shared.sendSms(phone: phone).subscribe { res in
                self.mainView.loading.stopAnimating()
                AccountUserDefaults.shared.saveUser(accountUserDefaultsModel: AccountUserDefaultsModel(token: res.data ?? ""))
                
            } onFailure: { _ in
                print("Failure")
                self.mainView.loading.stopAnimating()
            }.disposed(by: disposeBag)
        }
        
        
    
    
    
}
