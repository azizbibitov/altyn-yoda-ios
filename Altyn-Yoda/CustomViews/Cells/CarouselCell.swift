//
//  CarouselCell.swift
//  MIU-LOVE
//
//  Created by Aziz's MacBook Air on 22.02.2023.
//

import UIKit
import EasyPeasy
import Kingfisher

class CarouselCell: UICollectionViewCell {
    
    static let identifier = String(describing: CarouselCell.self)
    
    var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 6
        img.kf.indicatorType = .activity
        img.backgroundColor = .gray95
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.addSubview(image)
        image.easy.layout([Top(), Bottom(), Leading(20), Trailing(20), Height(190), Width(DeviceDimensions.shared.screenWidth()-40)])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
