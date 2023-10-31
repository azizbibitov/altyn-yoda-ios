//
//  ArticleCollectionViewCell.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 22.04.2023.
//

import UIKit
import EasyPeasy
import Kingfisher

class ArticleCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        
        didSet{
            self.image1.alpha = isSelected ? 1 : 0.4
        }
    }
    
    var image1: ZoomableImageView = {
        let img = ZoomableImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.kf.indicatorType = .activity
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .clear
        
        self.contentView.addSubview(image1)
        image1.easy.layout( Edges() )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
