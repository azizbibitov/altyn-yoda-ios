//
//  MapView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 10.04.2023.
//

import UIKit
import EasyPeasy
import GoogleMaps

class DefineLocationOnMapView: UIView {
    
    let header = HeaderWithBackBtn(title: "add_location".localized())
    
    var mapView = GMSMapView()
    
    var addLocationBtn: ZFRippleButton = {
        let btn = ZFRippleButton()
        btn.setImage(UIImage(named: "location-add")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        btn.tintColor = .gray95
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layer.cornerRadius = 56/2
        btn.backgroundColor = .white
        btn.rippleColor = .hoverColor!
        btn.rippleBackgroundColor = .customBtnBack!
        btn.ripplePercent = 3.0
        btn.trackTouchLocation = true
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowRadius = 0.0
        btn.layer.masksToBounds = false
        btn.isUserInteractionEnabled = true
        btn.addTarget(self, action: #selector(addLocationClick), for: .touchUpInside)
        return btn
    }()
    
    var addLocationClickCallback: ( ()-> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(mapView)
        mapView.easy.layout([
            Edges()
        ])
        
        mapView.addSubview(header)
        header.easy.layout([
            Top(), Leading(), Trailing()
        ])
        header.backgroundColor = .backgroundColor
        header.header.easy.layout(Height(DeviceDimensions.shared.topInset()+60))
        header.backBtn.easy.layout(CenterY(10))
        
        mapView.addSubview(addLocationBtn)
        addLocationBtn.easy.layout([
            Bottom(80).to(safeAreaLayoutGuide, .bottom), Size(56), Trailing(10)
        ])
        
    }
  
    
    @objc func addLocationClick(){
        addLocationClickCallback?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
