//
//  PhotosView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 22.04.2023.
//

import UIKit
import EasyPeasy
import Alamofire
import Kingfisher

class PhotosView: UIView {

    var width: CGFloat!
    var forUIImages: Bool = false
    var uiImages: [ZoomableImageView] = []
    
    var images: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var imagesUIImage: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var backImage2: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "closeButton")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = .textColor
        img.isUserInteractionEnabled = true
        return img
    }()
    
    var nextBtn: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "next")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = .textColor
        img.isUserInteractionEnabled = true
        return img
    }()
    
    var prevBtn: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "prev")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = .textColor
        img.isUserInteractionEnabled = true
        return img
    }()

    
    var articleTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .textColor
        lbl.font = UIFont(name: "Gilroy-Bold", size: 16)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var imagesScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentMode = .scaleToFill
        sv.clipsToBounds = true
        sv.alwaysBounceHorizontal = true
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 3
        layout.collectionView?.clipsToBounds = true
        layout.collectionView?.contentMode = .scaleToFill
        layout.itemSize = CGSize(width: 95, height: 100)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.isScrollEnabled = true
        cv.clipsToBounds = true
        cv.contentMode = .scaleToFill
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .backgroundColor
        cv.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: "articleViewCell")
        return cv
    }()
    
    lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.color = .primaryColor
        loading.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        return loading
    }()
    
    var articleBigImage: ZoomableImageView = {
        let img = ZoomableImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        return img
    }()
    
    var backImage2Callback: ( ()->Void )?
    var nextClickCallback: ( ()->Void )?
    var prevClickCallback: ( ()->Void )?
    
    override init(frame: CGRect){
    super.init(frame: frame)
        
        backImage2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backImage2Tap)))
        nextBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextTap)))
        prevBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prevTap)))
        
        self.addSubview(backImage2)
        backImage2.easy.layout([
            Trailing(20),
            Top(20).to(safeAreaLayoutGuide, .top)
        ])
        
       
        
        self.addSubview(imagesScrollView)
        imagesScrollView.easy.layout([
            CenterX(),
            CenterY(),
            Leading(20).to(safeAreaLayoutGuide, .leading),
            Trailing(20).to(safeAreaLayoutGuide, .trailing)
        ])
        
        self.addSubview(collectionView)
        collectionView.easy.layout([
            Leading().to(imagesScrollView, .leading),
            Trailing().to(imagesScrollView, .trailing),
            Bottom(20).to(safeAreaLayoutGuide, .bottom),
            Height(55)
        ])
        
        self.addSubview(nextBtn)
        nextBtn.easy.layout([
            CenterY().to(imagesScrollView, .centerY), Trailing(20), Size(44)
        ])
        
        self.addSubview(prevBtn)
        prevBtn.easy.layout([
            CenterY().to(imagesScrollView, .centerY), Leading(20), Size(44)
        ])
        
        addSubview(loading)
        loading.easy.layout([
            CenterX(), CenterY(-40), Size(80)
        ])
        loading.isHidden = true
    }
    
    func showLoading(){
        loading.isHidden = false
        loading.startAnimating()
        collectionView.isHidden = true
        imagesScrollView.isHidden = true
    }
    
    func dismissLoading(){
        loading.isHidden = true
        loading.stopAnimating()
        collectionView.isHidden = false
        imagesScrollView.isHidden = false
    }
    
    @objc func backImage2Tap() {
        backImage2Callback?()
    }
    
    @objc func nextTap() {
        nextClickCallback?()
    }
    
    @objc func prevTap() {
        prevClickCallback?()
    }
    

    func setupScrollView() {
        if forUIImages {
            imagesScrollView.easy.layout(Height(250))
            width = UIScreen.main.bounds.size.width - 40
            

            
            for i in 0..<imagesUIImage.count {
                let img = ZoomableImageView()
                imagesScrollView.addSubview(img)
                img.easy.layout([
                    Leading(CGFloat(i)*width),
                    Width(width),
                    Height(250)
                ])
                
                if i == imagesUIImage.count - 1 {
                    img.easy.layout(Trailing(2))
                }
                
                img.contentMode = UIView.ContentMode.scaleAspectFit
                img.backgroundColor = .backgroundColor
                
                img.image = imagesUIImage[i]
                
            }
        }else{
            imagesScrollView.easy.layout(Height(250))
            width = UIScreen.main.bounds.size.width - 40
            
            
            
            for i in 0..<images.count {
                let img = ZoomableImageView()
                imagesScrollView.addSubview(img)
                img.easy.layout([
                    Leading(CGFloat(i)*width),
                    Width(width),
                    Height(250)
                ])
                
                if i == images.count - 1 {
                    img.easy.layout(Trailing(2))
                }
                
                img.contentMode = UIView.ContentMode.scaleAspectFit
                img.backgroundColor = .backgroundColor
                
                let image_api_url = ApiUrl.shared.getPath(serverPath: images[i])
                
                img.kf.setImage(with: image_api_url)
                
            }
        }
        
        
        
    }
    
    
    
    func configure(images: [String]){
        self.images = images
    }
    
    func configure(images: [UIImage]){
        self.imagesUIImage = images
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

