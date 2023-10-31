//
//  HomeCollectionCarouselHeader.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 05.04.2023.
//

import UIKit
import ToosieSlide
import EasyPeasy
import AdvancedPageControl

class HomeCollectionCarouselHeader: UICollectionReusableView {
    
    static let identifier = String(describing: HomeCollectionCarouselHeader.self)
    
    var timer: Timer!
    var images: [String] = []
    var banners: [Banner] = []
    var dotsSpacer: Float = 4.0
    
    let spacer = UIView(frame: .zero)
    
    lazy var carouselCollection: UICollectionView = {
        let carouselFlow = UICollectionViewCarouselLayout()
        carouselFlow.itemSize = CGSize(width: DeviceDimensions.shared.screenWidth(), height: 190)
        carouselFlow.minimumLineSpacing = 3
        let collection = UICollectionView(collectionViewCarouselLayout: carouselFlow)
        collection.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.identifier)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        return collection
      }()
    
    var pageControl = AdvancedPageControlView()
    
    var helpLabel = GoldenWayLabel(font: .interMedium(size: 16), color: .textColor, text: "services".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        carouselCollection.delegate = self
        carouselCollection.dataSource = self
        
        
    }
    
    func setupPageControl(images: [String]){
        pageControl.drawer = ExtendedDotDrawer(numberOfPages: images.count,
                                                         height: 6.0,
                                                         width: 9.0,
                                                         space: CGFloat(dotsSpacer),
                                                         indicatorColor: UIColor.primaryColor,
                                                         dotsColor: .white,
                                                         isBordered: false,
                                                         borderWidth: 0.0,
                                                         indicatorBorderColor: .clear,
                                                         indicatorBorderWidth: 0.0)

        let ad = CGFloat(dotsSpacer*Float(images.count-1) + Float(9*(images.count+3)))
        pageControl.easy.layout([Width(ad)])
    }
    
    func setupSliderTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self , selector:
                                        #selector(startScrolling), userInfo: nil, repeats: true)

    }
    
    @objc func startScrolling() {
        var currentPage = carouselCollection.currentPage
        
        if currentPage == images.count {
            currentPage = 1
        }else{
            currentPage += 1
        }
        
        carouselCollection.setValue(1.0, forKeyPath: "contentOffsetAnimationDuration")
        carouselCollection.scrollToCell(at: currentPage-1, animated: true)
    }
    
    func setupUI() {
        
        addSubview(carouselCollection)
        carouselCollection.easy.layout([
            Top(20), Leading(), Trailing(), Height(190)
        ])
     
        addSubview(pageControl)
        pageControl.easy.layout([
            Bottom(2).to(carouselCollection, .bottom),
            Trailing(25).to(carouselCollection, .trailing)
        ])
        
        addSubview(helpLabel)
        helpLabel.easy.layout([
            Top(20).to(carouselCollection, .bottom),
            Leading(20),
            Bottom(20)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)

    }
    
}

extension HomeCollectionCarouselHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return images.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier, for: indexPath) as! CarouselCell
        cell.image.layer.cornerRadius = 6
        cell.image.kf.setImage(with: ApiUrl.shared.getPath(serverPath: images[indexPath.row]))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
        UIApplication.shared.open(NSURL(string: banners[indexPath.item].url ?? "")! as URL)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width

        pageControl.setPageOffset(offSet / width)
    }
}

