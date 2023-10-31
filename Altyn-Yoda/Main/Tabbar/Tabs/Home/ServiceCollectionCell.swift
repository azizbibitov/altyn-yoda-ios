//
//  ServiceCollectionCell.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 05.04.2023.
//

import UIKit
import EasyPeasy
import Kingfisher

class ServiceCollectionCell: UICollectionViewCell {
    
    static let identifier = String(describing: ServiceCollectionCell.self)
    
    var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.kf.indicatorType = .activity
        img.layer.cornerRadius = 4
        img.backgroundColor = .gray95
        return img
    }()
    
    let titleLabel = GoldenWayLabel(font: .interMedium(size: 16), color: .textColor, alignment: .left, numberOfLines: 1)
    
    let subTitleLabel = GoldenWayLabel(font: .interRegular(size: 12), color: .textColor, alignment: .left, numberOfLines: 0)
    
    
    var clickLayer: ZFRippleButton = {
       let btn = ZFRippleButton()
        btn.ripplePercent = 2
        btn.trackTouchLocation = true
        btn.rippleColor = .hoverColor!
        btn.rippleBackgroundColor = .white.withAlphaComponent(0.3)
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        return btn
    }()
    
    var clickCallback: ( ()-> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 9.06
        contentView.backgroundColor = UIColor.serviceCellColor
        
        contentView.addSubview(clickLayer)
        clickLayer.easy.layout([
            Edges()
        ])
        clickLayer.layer.cornerRadius = 9.06
        
        clickLayer.addSubview(image)
        image.easy.layout([
            Top(10), Leading(10), Height(75), Width(75)
        ])
        
        clickLayer.addSubview(titleLabel)
        titleLabel.easy.layout([
            Top(7).to(image, .bottom), Leading(10), Trailing(10),
        ])
        
        clickLayer.addSubview(subTitleLabel)
        subTitleLabel.easy.layout([
            Top(0).to(titleLabel, .bottom), Leading(10), Trailing(10), Bottom(10)
        ])
        
       
        
//        clickLayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
      
        
    }
    
    
    func makeInactive(){
        titleLabel.textColor = .textColor?.withAlphaComponent(0.5)
        subTitleLabel.textColor = .textColor?.withAlphaComponent(0.5)
        image.alpha = 0.5
        contentView.backgroundColor = UIColor.serviceCellColor?.withAlphaComponent(0.5)
    }
    
    func makeActive(){
        titleLabel.textColor = .textColor
        subTitleLabel.textColor = .textColor
        image.alpha = 1.0
        contentView.backgroundColor = UIColor.serviceCellColor
    }
   
    func setupSampleData(data: SampleData) {
        image.image = UIImage(named: data.image)
        titleLabel.text = data.title
        subTitleLabel.text = data.subTitle
    }
    
    func setupData(data: Service){
        image.kf.setImage(with: ApiUrl.shared.getPath(serverPath: data.image_path ?? ""))
        titleLabel.text = data.getLocalizedName()
        subTitleLabel.text = data.getLocalizedDescription()
    }
    
    @objc func click() {
        clickCallback?()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

