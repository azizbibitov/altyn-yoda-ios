//
//  NoconnectionView.swift
//  SalamExpress
//
//  Created by Parahat Caryyew on 13.03.2023.
//

import UIKit
import EasyPeasy
import RxSwift

class NoconnectionView: UIView {
    
    var disposeBag = DisposeBag()
    
    var wrapper = UIView()
    var cloudImage = UIImageView(name: "cloud-connection", width: 157, height: 57)
    var title = UILabel(text: "", font: .interMedium(size: 20), align: .center)
    var subtitle = UILabel(text: "", font: .interRegular(size: 12), color: UIColor(hexString: "#000"), align: .center)
    
    var sendButton: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "replay")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setTitle("refresh".localized(), for: .normal)
        btn.backgroundColor = UIColor(hexString: "#dadada")
        btn.setTitleColor(UIColor(hexString: "#323232"), for: .normal)
        btn.titleLabel?.font = .interRegular(size: 14)
        btn.tintColor = UIColor(hexString: "#323232")
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        btn.layer.cornerRadius = 4
        btn.imageView?.easy.layout(Trailing(10).to(btn.titleLabel!, .leading))
        return btn
    }()
    
    lazy var clickCallback: ( ()->() )? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.text = "no_connection".localized()
        subtitle.text = "            "
        
        
        let themeRaw = ThemeUserDefaults.shared.theme.rawValue
        var isDark: Bool = false
        if themeRaw == 0 { isDark = false } else { isDark = true }
        if isDark{
            cloudImage.image = UIImage(named: "cloud-connection-dark")
        }else{
            cloudImage.image = UIImage(named: "cloud-connection")
        }
        
        SettingsVC.shared.changeTheme.subscribe(onNext: { [weak self] isOn in
            if isOn{
                self?.cloudImage.image = UIImage(named: "cloud-connection-dark")
            }else{
                self?.cloudImage.image = UIImage(named: "cloud-connection")
            }
        }).disposed(by: disposeBag)
        
        setupUI()
    }
    
    func setupUI(){
        self.addSubview(wrapper)
        wrapper.easy.layout([
            Leading(>=50),
            Trailing(>=50),
            Width(<=300),
            CenterX(),
            CenterY()
        ])
        wrapper.addSubview(cloudImage)
        cloudImage.easy.layout([
            Top(),
            CenterX()
        ])
        wrapper.addSubview(title)
        title.easy.layout([
            Top(30).to(cloudImage, .bottom),
            Leading(),
            Trailing()
        ])
        wrapper.addSubview(subtitle)
        subtitle.easy.layout([
            Top(6).to(title, .bottom),
            Leading(),
            Trailing()
        ])
        wrapper.addSubview(sendButton)
        sendButton.easy.layout([
            Top(30).to(subtitle, .bottom),
            CenterX(),
            Bottom(),
            Height(44),
            Width(150)
        ])
    }
    
    @objc func btnTapped(){
        clickCallback?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
