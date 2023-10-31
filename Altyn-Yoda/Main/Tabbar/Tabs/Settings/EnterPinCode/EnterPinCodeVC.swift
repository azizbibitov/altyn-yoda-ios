//
//  EnterPinCodeVC.swift
//  Salam-beta
//
//  Created by Maksadow Meylis on 22.06.2022.
//

import UIKit
import EasyPeasy
import LocalAuthentication

class EnterPinCodeVC: UIViewController {
    
    var enterPinCode = false
    var repeatPinCode = false
    var firstPinCode: String = ""
    var headerTitle: String = ""
    
    var salamExpressLogo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "salam-express-logo")
        return img
    }()
    
    let passcode = PassCode()
    lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .textColor
        return btn
    }()

    var signBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "fingerprint")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    var lock: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "pin-code-lock")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = .primaryColor
        img.clipsToBounds = false
        return img
    }()
    
    var passcodeText: UILabel = {
        let lbl = UILabel()
        lbl.font = .interRegular(size: 14)
        lbl.text = "Lorem ipsum dolar sit"
        lbl.textColor = .textColor
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPasscodeTextField()
        
        signBtn.addTarget(self, action: #selector(fingerprintBtnClick), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        
        if enterPinCode { fingerprintBtnClick() }
        
        let themeRaw = ThemeUserDefaults.shared.theme.rawValue
        var isDark: Bool = false
        if themeRaw == 0 { isDark = false } else { isDark = true }
        if isDark{
            salamExpressLogo.image = UIImage(named: "altyn-yoda-logo-dark")
        }else{
            salamExpressLogo.image = UIImage(named: "altyn-yoda-logo")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
    }
    
    
    func setupUI() {
        view.backgroundColor = .whiteBlackColor
        
        view.addSubview(salamExpressLogo)
        salamExpressLogo.easy.layout([
            Top(100).to(view.safeAreaLayoutGuide, .top), CenterX(), Width(150), Height(87)
        ])
        
        view.addSubview(lock)
        lock.easy.layout([
            Top(60).to(salamExpressLogo, .bottom), CenterX()
        ])
        
        view.addSubview(passcodeText)
        passcodeText.easy.layout([
            Top(20).to(lock, .bottom), CenterX()
        ])
                
        view.addSubview(passcode)
        passcode.easy.layout([
            Top(30).to(passcodeText, .bottom), CenterX(), Height(44), Width(150)
        ])
        
        if self.enterPinCode {
            view.addSubview(signBtn)
            signBtn.easy.layout([
                Top(20).to(view.safeAreaLayoutGuide, .top), Trailing(20).to(view.safeAreaLayoutGuide, .trailing)
            ])
        } else {
            view.addSubview(backBtn)
            backBtn.easy.layout([
                Leading(10), Top(10).to(view.safeAreaLayoutGuide, .top), Size(40)
            ])
        }
    }
    
    func setupPasscodeTextField(){
        passcodeText.text = headerTitle
        passcode.becomeFirstResponder()
        passcode.didFinishedEnterCode = { code in
            let pinCode = code
            if pinCode.count == 4 {
                if self.enterPinCode  {
                    if let window = UIApplication.shared.windows.first {
                        
                        if pinCode == AccountUserDefaults.shared.getPinCodeApp() {
                            window.rootViewController = UINavigationController(rootViewController:  MainVC.shared)
                            window.makeKeyAndVisible()
                        } else {
                            self.passcode.shake()
                            self.passcode.clear()
                            self.passcode.becomeFirstResponder()
                        }
                    }
                } else {
                    if !self.repeatPinCode {
                        let vc = EnterPinCodeVC()
                        vc.headerTitle = "repeat_code".localized()
                        vc.firstPinCode = pinCode
                        vc.repeatPinCode = true
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    } else {
                        AccountUserDefaults.shared.savePinCodeApp(pinCode: pinCode)
                        guard var currentVCStack = self.navigationController?.viewControllers else { return }
                        currentVCStack.remove(at: currentVCStack.count - 2)
                        self.navigationController?.setViewControllers(currentVCStack, animated: true)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func alertTouchID() {
        let alertController = UIAlertController(title: "warning".localized(), message: "biometrics_not_found".localized(), preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "enter_password".localized(), style: .default, handler: nil)
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @objc func fingerprintBtnClick() {
        let context = LAContext()
        var error: NSError? = nil
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "TouchID or FaceID check for opening an application"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { succes, error in
                    DispatchQueue.main.async {
                        guard succes, error == nil else { return }
                            
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UINavigationController(rootViewController:  MainVC.shared)
                            window.makeKeyAndVisible()
                        }
                    }
                }
            } else {
                alertTouchID()
        }
    }
    
    
    @objc func backBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
