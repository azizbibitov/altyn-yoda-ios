//
//  RegistrationVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 04.04.2023.
//

import UIKit
import RxSwift
import CoreLocation

class RegistrationVC: UIViewController {
    
    var phone: String = ""
    lazy var disposeBag = DisposeBag()
    var coordinate: CLLocationCoordinate2D?
    
    var mainView: RegistrationView {
        return view as! RegistrationView
    }
    
    override func loadView() {
        super.loadView()
        view = RegistrationView()
        view.backgroundColor = .backgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardManager()
        
        setupCallBacks()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
    }
    
    func setupCallBacks(){
        mainView.nextBtn.clickCallback = { [weak self] in
            
            if self!.mainView.checkIfFieldsEmpty() {
                PopUpLancher.showWarningMessage(text: "fill_all_required_info".localized())
                return
            }
            if self?.coordinate != nil {
                self?.upsertClient(name: self?.mainView.nameField.textField.text ?? "", phoneNumber: self!.phone, address: self!.mainView.addressLocationView.textField.text ?? "", location: "\(self!.coordinate?.latitude ?? 0.0)x\(self!.coordinate?.longitude ?? 0.0)")
            }else{
                self?.upsertClient(name: self?.mainView.nameField.textField.text ?? "", phoneNumber: self!.phone, address: self!.mainView.addressLocationView.textField.text ?? "", location: "")
            }
          
            self?.mainView.showLoading()
              
        }
        
        mainView.addressLocationView.innerBtnClickCallback = { [weak self] in
            print("innerBtnClickCallback")
            let mapVC = DefineLocationOnMapVC()
            mapVC.modalPresentationStyle = .fullScreen
            mapVC.locationDelegate = self
            self?.navigationController?.pushViewController(mapVC, animated: true)
        }
        
    }
    
    
    func setupKeyboardManager(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 10, right: 0.0)
        mainView.scrollView.contentInset = contentInsets
        mainView.scrollView.scrollIndicatorInsets = contentInsets
    }
        
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        mainView.scrollView.contentInset = contentInsets
        mainView.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension RegistrationVC: AddLocationProtocol {
    func giveLocation(coordinate: CLLocationCoordinate2D, where_from: Bool) {
        self.coordinate = coordinate
        print("coordinate?.longitude", self.coordinate!.longitude)
        print("coordinate?.latitude", self.coordinate!.latitude)
        mainView.addressLocationView.locationId.text = "\(coordinate.longitude )"
        mainView.addressLocationView.locationAdded()
    }
    
  
        
}

//MARK: - API REQUESTS
extension RegistrationVC {
    func upsertClient(name: String, phoneNumber: String, address: String, location: String){
        AuthRequests.shared.upsertClient(name: name, phoneNumber: phoneNumber, address: address, location: location).subscribe { res in
            if res.data != nil {
                AccountUserDefaults.shared.saveUser(accountUserDefaultsModel: AccountUserDefaultsModel(uuid: res.data?.uuid ?? "", username: name, phone: phoneNumber, address: address, location: location, token: res.data?.token ?? ""))
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
            self.mainView.nextBtn.isUserInteractionEnabled = true
            self.mainView.dismissLoading()
        }.disposed(by: disposeBag)
    }
}

