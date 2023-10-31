//
//  UpdateProfileView.swift
//  SalamExpress
//
//  Created by Aziz's MacBook Air on 23.03.2023.
//

import UIKit
import EasyPeasy

class UpdateProfileView: UIView {
    
    let header = HeaderWithBackBtn(title: "profile".localized(), withBtn: true, btnImage: "edit")
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    var wrapper: UIStackView!
    
    var spacer = UIView()
    var spacer2 = UIView()
    var spacer3 = UIView()
    
    var nameField = CustomTextField(lbl: "full_name".localized(), pl: "")
    var phoneText = UILabel(text: "  +993", font: .interRegular(size: 14), align: .right)
    var phoneTextField = CustomTextField(lbl: "number".localized(), pl: "")
    let addressLocationView = LocationFieldWithTopLabel(lbl: "address".localized())
    
    
    var scanBtnClickCallback: ( ()-> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteBlackColor
        setupUI()
        addTargets()
    }
    
    func addTargets(){
        
    }
    
    func setupUI() {
        addSubview(header)
        header.easy.layout([
            Top().to(safeAreaLayoutGuide, .top), Leading(), Trailing()
        ])
        
        self.addSubview(scrollView)
        scrollView.easy.layout([
            Edges(),
            Top().to(header, .bottom)
        ])
        
        spacer.easy.layout(Height(20))
        spacer2.easy.layout(Height(40))
        
        setupUserDefaults()
        disable()
        phoneTextField.textField.leftView = phoneText
        phoneTextField.textField.leftViewMode = .always
        phoneTextField.textField.keyboardType = .numberPad
        
        wrapper = UIStackView(arrangedSubviews: [
                                                 nameField,
                                                 phoneTextField,
                                                 addressLocationView,
                                                 spacer3],
                              axis: .vertical,
                              spacing: 20,
                              align: .fill)
        
        scrollView.addSubview(wrapper)
        wrapper.easy.layout([
            Width(UIScreen.main.bounds.width - 40),
            Edges(UIEdgeInsets(top: 40, left: 20, bottom: 30, right: 20))
        ])
        
    }
    
    
    func disable(){
        nameField.disable()
        phoneText.textColor = UIColor.textColor?.withAlphaComponent(0.4)
        phoneTextField.disable()
        addressLocationView.disable()
    }
    
    func enable(){
        nameField.enable()
//        phoneText.textColor = .textColor
//        phoneTextField.enable()
        addressLocationView.enable()
    }
    
    func setupUserDefaults(){
        nameField.textField.text = AccountUserDefaults.shared.getUser().username
        phoneTextField.textField.text = String(AccountUserDefaults.shared.getUser().phone.dropFirst(4))
        addressLocationView.textField.text = AccountUserDefaults.shared.getUser().address
        let location = AccountUserDefaults.shared.getUser().location
        let coordinates = location.components(separatedBy: "x")
     
        if location != "" {
            addressLocationView.locationId.text = coordinates.first// lat
            addressLocationView.locationAdded()
        }
    }
    
    func checkIfFieldsEmpty() -> Bool{
        
        let nameField = nameField.checkIfEmpty()
        let phoneTextField = phoneTextField.checkIfEmpty()
        let addressLocationView = addressLocationView.checkIfEmpty()
        
        if nameField || phoneTextField || addressLocationView{
            return true
        }
        
        return false
    }
    
    @objc func scanBtnTap() {
        scanBtnClickCallback?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

