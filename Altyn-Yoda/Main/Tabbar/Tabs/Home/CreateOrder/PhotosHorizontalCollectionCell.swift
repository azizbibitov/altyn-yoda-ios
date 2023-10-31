//
//  PhotosHorizontalCollectionCell.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 09.04.2023.
//

import UIKit
import EasyPeasy
import Kingfisher

class PhotosHorizontalCollectionCell: UICollectionViewCell {
    
    static let identifier = String(describing: PhotosHorizontalCollectionCell.self)
    
    var photoImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.kf.indicatorType = .activity
        return img
    }()
    
    var trashBtn: ZFRippleButton = {
        let btn = ZFRippleButton()
        btn.setImage(UIImage(named: "trash"), for: .normal)
        btn.backgroundColor = UIColor(hexString: "#FF6363")
        btn.layer.cornerRadius = 4
        btn.ripplePercent = 2
        btn.trackTouchLocation = true
        btn.rippleColor = UIColor(hexString: "#FF6363")
        btn.rippleBackgroundColor = .white.withAlphaComponent(0.3)
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        return btn
    }()
    
    var clickCallback: ( ()-> Void )?
    var itemClickCallback: ( ()-> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .whiteBlackColor
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(itemTap)))
        
        contentView.easy.layout([
            Width(105), Height(105)
        ])
        
        contentView.addSubview(photoImage)
        photoImage.easy.layout([
            Edges(5)
        ])
        
        contentView.addSubview(trashBtn)
        trashBtn.easy.layout([
            Bottom().to(photoImage, .bottom),
            Trailing().to(photoImage, .trailing),
            Size(23)
        ])
        
        contentView.layer.cornerRadius = 6
    }
    
    func setImage(image: UIImage){
        photoImage.image = image
    }
    
    func setImage(image: String){
        photoImage.kf.setImage(with: ApiUrl.shared.getPath(serverPath: image))
        trashBtn.isHidden = true
    }
    
    @objc func click() {
        clickCallback?()
    }
    
    @objc func itemTap() {
        itemClickCallback?()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

