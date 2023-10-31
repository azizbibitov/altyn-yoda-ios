//
//  HeaderView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 12.02.2023.
//

import UIKit
import EasyPeasy
import RxSwift

class GoldenWayHeader: UIView {
    
    var disposeBag = DisposeBag()

    var header: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBlackColor
        return view
    }()
    
    var goldenWayLogo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "altyn-yoda-logo")
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
   
    let notificationsBtn = CustomButton(imageName: "notifications", withBlueCircle: true, withOriginalImage: false, withBackgroundColor: true)
    
    var notificationsClickCallback: ( ()-> Void )?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTargets()
        setupHeader()

        let themeRaw = ThemeUserDefaults.shared.theme.rawValue
        var isDark: Bool = false
        if themeRaw == 0 { isDark = false } else { isDark = true }
        if isDark{
            goldenWayLogo.image = UIImage(named: "altyn-yoda-logo-dark")
        }else{
            goldenWayLogo.image = UIImage(named: "altyn-yoda-logo")
        }
        
        SettingsVC.shared.changeTheme.subscribe(onNext: { [weak self] isOn in
            if isOn{
                self?.goldenWayLogo.image = UIImage(named: "altyn-yoda-logo-dark")
            }else{
                self?.goldenWayLogo.image = UIImage(named: "altyn-yoda-logo")
            }
        }).disposed(by: disposeBag)
        
    }

    func addTargets(){
        notificationsBtn.isUserInteractionEnabled = true
        notificationsBtn.addTarget(self, action: #selector(notificationsBtnTap), for: .touchUpInside)
    }

    func setupHeader() {

        addSubview(header)
        header.easy.layout([
            Edges(), Height(60)
        ])

        header.addSubview(goldenWayLogo)
        goldenWayLogo.easy.layout([
            CenterY(), Leading(20), Width(60), Height(35)
        ])

     

        header.addSubview(notificationsBtn)
        notificationsBtn.easy.layout([
            CenterY(), Trailing(20), Size(40)
        ])

    }

    @objc func notificationsBtnTap() {
        notificationsClickCallback?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
