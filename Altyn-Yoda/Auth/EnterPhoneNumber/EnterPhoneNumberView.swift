//
//  EnterEmailView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 03.04.2023.
//

import UIKit
import EasyPeasy


class EnterPhoneNumberView: UIView {
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    var wrapper: UIStackView!
    
    var logo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "altyn-yoda-logo")
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        return logo
    }()
    var logoWrapper = UIView()
    var spacer = UIView()
    var spacer2 = UIView()
    
    var phoneText = UILabel(text: "  +993", font: .interRegular(size: 14), align: .right)
    var phoneTextField = CustomTextField(lbl: "number".localized(), pl: "")
    
    var helpText = LinkTextView()
//    var linkText = "“Отправить”"
//    var underlinedText = "политикой конфиденциальности"
//    var underlinedText2 = "правилами пользования"
    
    var underlinedNextText = "underlinedText".localized()
    var termsOfUserLinkText = "terms_of_use_links".localized()
    var privacyPolicyLinkText = "privacy_policy_link".localized()
    
    var helpTextWrapper = UIView()
    

    
    
    var nextButton = Button(title: "next".localized())
    
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
        
    }
    
    func setupUI(){
        
        self.addSubview(scrollView)
        scrollView.easy.layout([Edges(), Top(40).to(safeAreaLayoutGuide, .top) ])
        
        setupLogo()
        setupTextField()
        spacer.easy.layout(Height(20))
        setupHelpText()
        
        wrapper = UIStackView(arrangedSubviews: [logoWrapper,
                                                 spacer,
                                                 phoneTextField,
                                                 helpTextWrapper,
                                                 nextButton,
                                                 spacer2],
                              axis: .vertical,
                              spacing: 20,
                              align: .fill)
        
        scrollView.addSubview(wrapper)
        wrapper.easy.layout([ Leading(20),Trailing(20),Top(),Bottom(30),Width(UIScreen.main.bounds.width - 40),])
        
        addSubview(loading)
        loading.easy.layout([
            CenterX(), CenterY(-40), Size(80)
        ])
        dismissLoading()
    }
    
    func checkFields() -> Bool{
        let phoneTextField = phoneTextField.checkIfEmpty()
        if phoneTextField {
            return true
        }
        return false
    }
    
    func setupHelpText(){
        
        helpText.text = "help_text_prefix".localized() + underlinedNextText + "help_text_after_next_suffix".localized() + privacyPolicyLinkText + "and".localized() + termsOfUserLinkText + "help_text_suffix".localized()
        
        helpText.addGoldenWayLinks(
            [
                privacyPolicyLinkText: getPrivacyPolicyLink(),
                termsOfUserLinkText: getTermsOfUseLink()
            ],
            [
                underlinedNextText
            ]
        )
        helpText.onLinkTap = { url in
            return true
        }
        
        helpTextWrapper.addSubview(helpText)
        
        helpText.easy.layout([ Edges(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)) ])
        
    }
    
    func getPrivacyPolicyLink() -> String {
        let languageCode = AccountUserDefaults.shared.getLanguageCode()
        switch languageCode {
        case "en":
            return "https://altynyoda.com.tm/privacy-policy-en"
        case "ru":
            return "https://altynyoda.com.tm/privacy-policy-ru"
        case "tk":
            return "https://altynyoda.com.tm/privacy-policy-tm"
        default: return ""
        }
    }
    
    func getTermsOfUseLink() -> String {
        let languageCode = AccountUserDefaults.shared.getLanguageCode()
        switch languageCode {
        case "en":
            return "https://altynyoda.com.tm/terms-of-use-en"
        case "ru":
            return "https://altynyoda.com.tm/terms-of-use-ru"
        case "tk":
            return "https://altynyoda.com.tm/terms-of-use-tm"
        default: return ""
        }
    }
    
    func setupLogo(){
        logoWrapper.addSubview(logo)
        logoWrapper.easy.layout(Height(65))
        logo.easy.layout(CenterX(), Height(65), Width(110))
        
        let themeRaw = ThemeUserDefaults.shared.theme.rawValue
        var isDark: Bool = false
        if themeRaw == 0 { isDark = false } else { isDark = true }
        if isDark{
            logo.image = UIImage(named: "altyn-yoda-logo-dark")
        }else{
            logo.image = UIImage(named: "altyn-yoda-logo")
        }
    }
    
    func setupTextField(){
        phoneTextField.textField.leftView = phoneText
        phoneTextField.textField.leftViewMode = .always
        phoneTextField.textField.keyboardType = .numberPad
    }
   
    func showLoading(){
        loading.isHidden = false
        loading.startAnimating()
    }
    
    func dismissLoading(){
        loading.isHidden = true
        loading.stopAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

