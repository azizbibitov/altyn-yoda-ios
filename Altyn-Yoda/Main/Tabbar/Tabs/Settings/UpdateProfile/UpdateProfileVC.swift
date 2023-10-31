//
//  UpdateProfileVC.swift
//  SalamExpress
//
//  Created by Aziz's MacBook Air on 23.03.2023.
//

import UIKit
import RxSwift
import CoreLocation
import GoogleMaps

class UpdateProfileVC: UIViewController {
    
    var isEditable: Bool = false
    lazy var disposeBag = DisposeBag()
    var coordinate: CLLocationCoordinate2D?
    
    var mainView: UpdateProfileView {
        return view as! UpdateProfileView
    }
    
    override func loadView() {
        super.loadView()
        view = UpdateProfileView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardManager()
        setupCallbacks()
        mainView.phoneTextField.textField.delegate = self
        
        getUserLocation()
    }
    
    func getUserLocation(){
        let location = AccountUserDefaults.shared.getUser().location
        let coordinates = location.components(separatedBy: "x")
        guard let lat = Double(coordinates.first ?? "0.0"),
              let lng = Double(coordinates.last ?? "0.0") else { return}
        
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    
    func setupCallbacks(){
        mainView.header.backBtnClickCallback = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        mainView.header.customBtnClickCallback = { [weak self] in
            print("customBtnClickCallback")
            
            if self!.isEditable {
                
               
                
                if self!.mainView.checkIfFieldsEmpty() {
                    PopUpLancher.showWarningMessage(text: "fill_all_required_info".localized())
                    return
                }
               
                let location = "\(self!.coordinate?.latitude ?? 0.0)x\(self!.coordinate?.longitude ?? 0.0)"
                self?.upsertClient(name: self?.mainView.nameField.textField.text ?? "", phoneNumber: self!.mainView.phoneTextField.textField.text ?? "", address: self!.mainView.addressLocationView.textField.text ?? "", location: location)
                
                
            }else{
                self?.mainView.enable()
                self?.changeEditableStatus()
            }
            
          
            
//            if self!.isEditable == true{
//                self?.mainView.enable()
//            }else{
//
//
//                let location = "\(self!.coordinate?.latitude ?? 0.0)x\(self!.coordinate?.longitude ?? 0.0)"
//
//                if self!.mainView.checkIfFieldsEmpty() {
//                    PopUpLancher.showWarningMessage(text: "fill_all_required_info".localized())
//                    return
//                }
//                self?.mainView.disable()
//                self?.upsertClient(name: self?.mainView.nameField.textField.text ?? "", phoneNumber: self!.mainView.phoneTextField.textField.text ?? "", address: self!.mainView.addressLocationView.textField.text ?? "", location: location)
//
//            }
            
        }
        
        mainView.addressLocationView.innerBtnClickCallback = { [weak self] in
            print("innerBtnClickCallback")
            let mapVC = DefineLocationOnMapVC()
            mapVC.modalPresentationStyle = .fullScreen
            mapVC.locationDelegate = self
            self?.navigationController?.pushViewController(mapVC, animated: true)
        }
        
        
    }
    
    func changeEditableStatus(){
        self.isEditable.toggle()
        if self.isEditable {
            self.mainView.header.customBtn.btnInIcon.setImage(UIImage(named: "success-btn-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.mainView.header.customBtn.btnInIcon.tintColor = .primaryColor
        }else{
            self.mainView.header.customBtn.btnInIcon.setImage(UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate) , for: .normal)
            self.mainView.header.customBtn.btnInIcon.tintColor = .textColor
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

extension UpdateProfileVC: AddLocationProtocol {
    func giveLocation(coordinate: CLLocationCoordinate2D, where_from: Bool) {
        self.coordinate = coordinate
        print("coordinate?.longitude", self.coordinate!.longitude)
        print("coordinate?.latitude", self.coordinate!.latitude)
        mainView.addressLocationView.locationId.text = "\(coordinate.longitude)"
        mainView.addressLocationView.locationAdded()
    }
    
    
}


extension UpdateProfileVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mainView.phoneTextField.textField {
            if range.location == 8 { return false }
            switch textField.text!.count + range.length {
            case 0:  return string == "6"
            case 1:  return (string > "0") && (string < "6")
            default: return string == string.filter("0123456789".contains)
            }
        }else{
            return true
        }
        
    }
    
}


//MARK: - API REQUESTS
extension UpdateProfileVC {
    func upsertClient(name: String, phoneNumber: String, address: String, location: String){
        AuthRequests.shared.upsertClient(name: name, phoneNumber: phoneNumber, address: address, location: location).subscribe { res in
            AccountUserDefaults.shared.saveUser(accountUserDefaultsModel: AccountUserDefaultsModel(uuid: AccountUserDefaults.shared.getUser().uuid, username: name, phone: "+993\(phoneNumber)", address: address, location: location, token: AccountUserDefaults.shared.getUser().token))
            MainChildTabBarController.changeLanguage.onNext(())
            PopUpLancher.showSuccessMessage(text: "profile_updated".localized())
            
            self.mainView.disable()
            self.changeEditableStatus()
            
        } onFailure: { _ in
            print("Failure")
        }.disposed(by: disposeBag)
    }
}


