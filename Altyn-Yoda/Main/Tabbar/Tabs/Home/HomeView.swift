//
//  HomeView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 04.04.2023.
//

import UIKit
import EasyPeasy

class HomeView: UIView {
    
    lazy var noConnection = NoconnectionView()
    lazy var noContent = NoContent()
    lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.color = .primaryColor
        loading.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        return loading
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: -2, left: 20, bottom: 6, right: 20)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HomeCollectionCarouselHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCollectionCarouselHeader.identifier)
        cv.register(ServiceCollectionCell.self, forCellWithReuseIdentifier: ServiceCollectionCell.identifier)
        cv.backgroundColor = .whiteBlackColor
        cv.isScrollEnabled = true
        cv.bounces = true
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.clipsToBounds = true
        cv.refreshControl = UIRefreshControl()
        cv.keyboardDismissMode = .onDrag
        return cv
    }()
    
    var floatingBtn: ZFRippleButton = {
        let btn = ZFRippleButton()
        btn.layer.shadowRadius = 10
        btn.layer.shadowOpacity = 0.3
        btn.setImage(UIImage(named: "clock-fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setImage(UIImage(named: "clock-fill")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        btn.tintColor = .white
        btn.backgroundColor = .primaryColor
        btn.rippleColor = UIColor.hoverColor!.withAlphaComponent(0.4)
        btn.rippleBackgroundColor = .primaryColor!
        btn.ripplePercent = 2.0
        btn.trackTouchLocation = true
        btn.layer.cornerRadius = 30
        return btn
    }()
    
    var floatingBtnClickCallback: ( ()-> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteBlackColor
        
        floatingBtn.addTarget(self, action: #selector(floatingBtnTap), for: .touchUpInside)
        setupUI()
    }
    
    
    func setupUI() {
        
        addSubview(collectionView)
        collectionView.easy.layout(Leading(), Trailing(), Top(), Bottom())
        
        addSubview(floatingBtn)
        floatingBtn.easy.layout([
//            Trailing(20),
//            Size(60)
        ])
        
        addSubview(noConnection)
        noConnection.easy.layout(Edges())
        
        addSubview(noContent)
        noContent.easy.layout(Edges())
        
        addSubview(loading)
        loading.easy.layout([
            CenterX(), CenterY(-40), Size(80)
        ])
    }
    
    func showLoading(){
        loading.isHidden = false
        loading.startAnimating()
        noConnection.isHidden = true
        collectionView.isHidden = true
        noContent.isHidden = true
    }
    
    func showNoConnection(){
        loading.isHidden = true
        loading.stopAnimating()
        noConnection.isHidden = false
        collectionView.isHidden = true
        noContent.isHidden = true
    }
    
    func showNoContent(){
        loading.isHidden = true
        loading.stopAnimating()
        noConnection.isHidden = true
        collectionView.isHidden = true
        noContent.isHidden = false
    }
    
    func showData(){
        loading.isHidden = true
        loading.stopAnimating()
        noConnection.isHidden = true
        collectionView.isHidden = false
        noContent.isHidden = true
    }
    
    @objc func floatingBtnTap() {
        floatingBtnClickCallback?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
