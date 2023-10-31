//
//  RegistrationView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 04.04.2023.
//

import UIKit
import EasyPeasy

class RegistrationView: UIView {
    
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
    
    
    var logo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "altyn-yoda-logo")
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        return logo
    }()
    var logoWrapper = UIView()
    var nameField = CustomTextField(lbl: "full_name".localized(), pl: "")
    
    let addressLocationView = LocationFieldWithTopLabel(lbl: "address".localized())
    
    var nextBtn = Button(title: "next".localized())
    
    var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.color = .white
        loading.backgroundColor = .black28.withAlphaComponent(0.7)
        loading.layer.cornerRadius = 10
        loading.stopAnimating()
        return loading
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        let themeRaw = ThemeUserDefaults.shared.theme.rawValue
        var isDark: Bool = false
        if themeRaw == 0 { isDark = false } else { isDark = true }
        if isDark {
            logo.image = UIImage(named: "altyn-yoda-logo-dark")
        }else{
            logo.image = UIImage(named: "altyn-yoda-logo")
        }
    }
    
    func setupUI(){
        nextBtn.fill()
        
        self.addSubview(scrollView)
        scrollView.easy.layout([
            Edges(),
            Top().to(safeAreaLayoutGuide, .top)
        ])
        
        setupLogo()
        
        spacer.easy.layout(Height(20))
        spacer2.easy.layout(Height(40))
        
        wrapper = UIStackView(arrangedSubviews: [logoWrapper,
                                                 spacer,
                                                 nameField,
                                                 addressLocationView,
                                                 spacer2,
                                                 nextBtn,
                                                 spacer3],
                              axis: .vertical,
                              spacing: 20,
                              align: .fill)
        
        
        scrollView.addSubview(wrapper)
        wrapper.easy.layout([
            Width(UIScreen.main.bounds.width - 40),
            Edges(UIEdgeInsets(top: 40, left: 20, bottom: 30, right: 20))
        ])
        
        addSubview(loading)
        loading.easy.layout([
            CenterX(), CenterY(-40), Size(80)
        ])
        dismissLoading()
    }
    
    func checkIfFieldsEmpty() -> Bool{
        
        let nameField = nameField.checkIfEmpty()
        let addressLocationView = addressLocationView.checkIfEmpty()
        
        if nameField || addressLocationView {
            return true
        }
        
        return false
    }
    
    func showLoading(){
        loading.isHidden = false
        loading.startAnimating()
    }
    
    func dismissLoading(){
        loading.isHidden = true
        loading.stopAnimating()
    }
    
    func setupLogo(){
        logoWrapper.addSubview(logo)
        logoWrapper.easy.layout(Height(65))
        logo.easy.layout(CenterX(), Height(65), Width(110))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

