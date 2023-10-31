//
//  EnterEmailVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 03.04.2023.
//

import UIKit
import RxSwift

class EnterPhoneNumberVC: UIViewController, UITextFieldDelegate {
    
    lazy var disposeBag = DisposeBag()
    
    var mainView: EnterPhoneNumberView {
       return view as! EnterPhoneNumberView
    }
    
    override func loadView() {
        super.loadView()
        view = EnterPhoneNumberView()
        view.backgroundColor = .whiteBlackColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = true
        
        mainView.phoneTextField.textField.delegate = self

        mainView.nextButton.clickCallback = { [weak self] in
            if self!.mainView.checkFields(){
                PopUpLancher.showWarningMessage(text: "fill_all_required_info".localized())
                return
            }

            
            self?.sendSms(phone: self?.mainView.phoneTextField.textField.text ?? "")
            self?.mainView.nextButton.isUserInteractionEnabled = false
            self?.mainView.showLoading()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.phoneTextField.textField.becomeFirstResponder()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (range.location >= 7)&&(textField.text?.count == range.location) {
            mainView.nextButton.blackColor()
        } else {
            mainView.nextButton.disabled()
        }
        
        if range.location == 8 { return false }
        switch textField.text!.count + range.length {
        case 0:  return string == "6"
        case 1:  return (string > "0") && (string < "6")
        default: return string == string.filter("0123456789".contains)
        }
    }
    
}

extension EnterPhoneNumberVC {
    func sendSms(phone: String) {
        AuthRequests.shared.sendSms(phone: phone).subscribe { res in
            AccountUserDefaults.shared.saveUser(accountUserDefaultsModel: AccountUserDefaultsModel(token: res.data ?? ""))
            let vc = EnterCodeVC()
            vc.phoneText = "+993 " + phone
            vc.phone = "+993" + phone
            self.mainView.nextButton.isUserInteractionEnabled = true
            self.mainView.dismissLoading()
            self.navigationController?.pushViewController(vc, animated: true)
        } onFailure: { _ in
            print("Failure")
            self.mainView.nextButton.isUserInteractionEnabled = true
            self.mainView.dismissLoading()
        }.disposed(by: disposeBag)
    }
}

