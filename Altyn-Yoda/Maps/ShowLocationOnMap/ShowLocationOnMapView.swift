//
//  ShowLocationOnMapView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 18.04.2023.
//

import UIKit
import EasyPeasy
import GoogleMaps

class ShowLocationOnMapView: UIView {
    
    let header = HeaderWithBackBtn(title: "see_location".localized())
    
    var mapView = GMSMapView()
    
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
        
    }
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

