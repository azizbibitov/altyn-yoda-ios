//
//  OnBoardingsView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 25.03.2023.
//

import UIKit
import ToosieSlide
import EasyPeasy
import AdvancedPageControl

class OnBoardingView: UIView {
    
    var dotsSpacer: Float = 4.0
    var images: [String] = []
    
    var carouselHeight = 280.0
    
    var skipBtn: ZFRippleButton = {
        let btn = ZFRippleButton()
        btn.setTitle("skip".localized(), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .whiteBlackForBtn
        btn.rippleColor = .blackBtnHover!
        btn.rippleBackgroundColor = .whiteBlackForBtn!
        btn.ripplePercent = 3.0
        btn.trackTouchLocation = true
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    lazy var carouselCollection: UICollectionView = {
        let carouselFlow = UICollectionViewCarouselLayout()
        carouselFlow.itemSize = CGSize(width: DeviceDimensions.shared.screenWidth(), height: carouselHeight)
        carouselFlow.minimumLineSpacing = 3
        let collection = UICollectionView(collectionViewCarouselLayout: carouselFlow)
        collection.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.identifier)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        return collection
      }()
    
    let title = GoldenWayLabel(font: .interSemiBold(size: 16), color: .textColor, alignment: .left, numberOfLines: 0, text: "Ваш переезд - наша забота!")
    
    let subTitle = GoldenWayLabel(font: .interRegular(size: 16), color: .textColor, alignment: .left, numberOfLines: 0, text: "Доверьте свой переезд профессионалам!")
    
    
    var nextBtn: CustomButton = {
        let btn = CustomButton(imageName: "arrow-right", cornerRadius: 25, withOriginalImage: false, withBackgroundColor: true)
        btn.backgroundColor = .whiteBlackForBtn
        btn.btnInIcon.setImage(UIImage(named: "arrow-right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.btnInIcon.tintColor = .white
        btn.setTitleColor(.white, for: .normal)
        btn.rippleColor = .blackBtnHover!
        btn.rippleBackgroundColor = .whiteBlackForBtn!
        return btn
    }()
    
    var pageControl = AdvancedPageControlView()
    
    var nextClickCallback: ( ()-> Void )?
    var skipClickCallback: ( ()-> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteBlackColor
        
        setupUI()
        addTargets()
    }
    
    func addTargets(){
        nextBtn.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        skipBtn.addTarget(self, action: #selector(skipClick), for: .touchUpInside)
    }
    
    func setupPageControl(images: [String]){
        pageControl.drawer = ExtendedDotDrawer(numberOfPages: images.count,
                                               height: 6.0,
                                               width: 16.0,
                                               space: CGFloat(dotsSpacer),
                                               indicatorColor: UIColor.primaryColor,
                                               dotsColor: .textColor,
                                               isBordered: false,
                                               borderWidth: 0.0,
                                               indicatorBorderColor: .clear,
                                               indicatorBorderWidth: 0.0)
        
        let ad = CGFloat(dotsSpacer*Float(images.count-1) + Float(14*(images.count+3)))
        pageControl.easy.layout([Width(ad)])
    }
    
    func setupUI(){
        
        addSubview(skipBtn)
        skipBtn.easy.layout([
            Top(30).to(safeAreaLayoutGuide, .top), Trailing(20), Width(130), Height(40)
        ])
        
        addSubview(carouselCollection)
        carouselCollection.easy.layout([
            Top(100).to(skipBtn, .bottom), Leading(), Trailing(), Height(carouselHeight)
        ])
        
        addSubview(nextBtn)
        nextBtn.easy.layout([
            Trailing(20), Bottom(30).to(safeAreaLayoutGuide, .bottom), Size(50)
        ])
        
        addSubview(pageControl)
        pageControl.easy.layout([
            Leading(20), CenterY().to(nextBtn, .centerY)
        ])
        
        addSubview(subTitle)
        subTitle.easy.layout([
            Bottom(30).to(nextBtn, .top),
            Leading(20), Trailing(20)
        ])
        
        addSubview(title)
        title.easy.layout([
            Bottom(10).to(subTitle, .top),
            Leading(20)
        ])
        
    }
    
    
    @objc func nextClick(){
        nextClickCallback?()
    }
    
    @objc func skipClick(){
        skipClickCallback?()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

