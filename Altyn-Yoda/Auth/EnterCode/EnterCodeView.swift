//
//  EnterCodeView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 03.04.2023.
//

import UIKit
import EasyPeasy
import Localize_Swift


enum CodeCheckStatus{
    case right
    case wrong
    case notFilled
}

class EnterCodeView: UIView {
    
    var timer: Timer?
    lazy var remainingTime = 60
    
    var oneTimeFieldWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .oneTimeFieldColor
        view.layer.borderColor = UIColor(hexString: "#121212").withAlphaComponent(0.24).cgColor
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var codeView = UIView()
    lazy var codeTextField = OneTimeCodeTextField()
//    lazy var frames: [TextFieldFrame] = []
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.color = .white
        loading.backgroundColor = .black28.withAlphaComponent(0.7)
        loading.layer.cornerRadius = 10
        loading.stopAnimating()
        return loading
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
    var spacer3 = UIView()
    
    var title = UILabel(text: "SMS".localized(), font: .interSemiBold(size: 20), align: .left)
    var subtitle = UILabel(text: "received_code".localized(),
                           font: .interMedium(size: 12),
                           align: .left)
    
    var timerText = UILabel(text: "повторить через 54 сек",
                            font: .interRegular(size: 12),
                            align: .center)
    var changeNumberBtn = Button(title: "change_number".localized(), fsize: 12)
    
    var resendClickCallback: ( () -> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        timerText.text = "resend_code_beginning".localized() + " 119 " + "resend_code_ending".localized()
        
        timerText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendCodeClick)))
        
        addSubview(scrollView)
        scrollView.easy.layout([Edges(), Top(40).to(safeAreaLayoutGuide, .top) ])
       
        
        setupLogo()
        spacer.easy.layout(Height(110))
        spacer3.easy.layout(Height(7))
        
        setupTextField()
        oneTimeFieldWrapper.easy.layout(Height(50), Width(DeviceDimensions.shared.screenWidth()-40))
        
        wrapper = UIStackView(arrangedSubviews: [logoWrapper,
//                                                 spacer,
                                                 title,
//                                                 spacer3,
                                                 subtitle,
                                                 oneTimeFieldWrapper,
                                                 changeNumberBtn,
                                                 timerText,
                                                 spacer2],
                              axis: .vertical,
                              spacing: 20,
                              align: .fill)
        
        wrapper.setCustomSpacing(7, after: title)
        
        scrollView.addSubview(wrapper)
        wrapper.easy.layout([ Leading(20),Trailing(20),Top(),Bottom(30),Width(UIScreen.main.bounds.width - 40),])
        
        addSubview(loading)
        loading.easy.layout([
            CenterX(), CenterY(-40), Size(80)
        ])
        dismissLoading()
            
    }
    
    func setupTextField() {
        oneTimeFieldWrapper.addSubview(codeView)
        codeView.easy.layout([
            Top(3.5), CenterX(), Bottom(3.5), Width(120)
        ])
        
        codeTextField.configure(withSlotCount: 4, andSpacing: 13)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        for _ in 0..<4 {
            let line = UIView()
            line.backgroundColor = .textColor
            line.easy.layout([
                Height(2), Width(24)
            ])
            stackView.addArrangedSubview(line)
        }

        codeView.addSubview(codeTextField)
        codeTextField.easy.layout([
            Top(), Leading(), Trailing(), Bottom(1)
        ])
        
        codeView.addSubview(stackView)
        stackView.easy.layout([
            Leading(), Trailing(), Bottom(), Height(2)
        ])
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
    
    func startTimer() {
        remainingTime = 120
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        timerText.isUserInteractionEnabled = false
    }
    
    func timerFinished() {
        timer?.invalidate()
        timerText.text = "resend_code".localized()
        timerText.isUserInteractionEnabled = true
    }
    
    @objc func countDown() {
        self.remainingTime -= 1
        timerText.text = "resend_code_beginning".localized() + " \(remainingTime) " + "resend_code_ending".localized()
        
        if (self.remainingTime < 1) {
            timerFinished()
        }
    }
        
    @objc func resendCodeClick() {
        if remainingTime == 0 {
            startTimer()
            resendClickCallback?()
        }
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

