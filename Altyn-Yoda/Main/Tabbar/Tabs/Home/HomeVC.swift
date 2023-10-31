//
//  HomeVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 04.04.2023.
//

import UIKit
import RxSwift
import EasyPeasy

class HomeVC: UIViewController {
    
    lazy var disposeBag = DisposeBag()
    
    var images: [String] = []//["iOS_photo", "night_city", "think-different"]
    
    var services: [Service] = []
    var banners: [Banner] = []
    
    var collectionHeader: HomeCollectionCarouselHeader!
    
    var mainView: HomeView {
        return view as! HomeView
    }
    
    override func loadView() {
        super.loadView()
        view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.showLoading()
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        getAllBanners()
        setupCallbacks()
//        setupButtonAnimation()
//        self.mainView.floatingBtn.layer.timeOffset = 0.0
        
        if let tab = tabBarController {
            let heigth = tab.tabBar.frame.size.height as CGFloat
            let inset = DeviceDimensions.shared.bottomInset()
            print("heigthX", heigth)
            print("insetX", inset)
            mainView.floatingBtn.easy.layout([
                Bottom(49 + inset + 50),
                Trailing(20),
                Size(60)
            ])
        }
        
    }
    
    @objc func handleRefreshControl() {
        self.getAllBanners()
        self.mainView.collectionView.refreshControl?.endRefreshing()
    }
    
    func setupCallbacks() {
        mainView.noConnection.clickCallback = { [weak self] in
            self!.mainView.showLoading()
            self!.getAllBanners()
        }
        mainView.floatingBtnClickCallback = { [weak self] in
            print("floatingBtnClickCallback")
            self?.navigationController?.pushViewController(ActiveOrdersVC(), animated: true)
        }
    }


}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if self.services.count != 0 {
            if self.collectionHeader == nil{
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeCollectionCarouselHeader.identifier, for: indexPath) as! HomeCollectionCarouselHeader
                
                headerView.images = self.images
                headerView.banners = self.banners
                headerView.setupPageControl(images: self.images)
                headerView.setupSliderTimer()
                
                
                collectionHeader = headerView
                return collectionHeader
            }else{
                return collectionHeader
            }
        }else{
            return UICollectionReusableView()
        }
        
    }
    
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return ColumnCollectionViewHelper.getNColumnCGSize(n: 2, height: 170, horizontalPadding: 20, minimumItemSpacing: 18)
        
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18.0
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceCollectionCell.identifier, for: indexPath) as! ServiceCollectionCell
        cell.setupData(data: services[indexPath.row])
        cell.clickCallback = { [weak self] in
            print("clickCallback")
            if self!.services[indexPath.row].status == 0 {
                let actionPopup = GoldenWayActionPopupVC(actionLabelText: "want_to_set_your_cridentials".localized(), yesActionText: "yes".localized(), noActionText: "no".localized())
                actionPopup.indexPath = indexPath
                actionPopup.modalPresentationStyle  = .overFullScreen
                actionPopup.modalTransitionStyle    = .crossDissolve
                actionPopup.delegate = self
                self?.present(actionPopup, animated: true)
            }else{
                let alert = UIAlertController(title: "this_service_not_available".localized(), message: "", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
          
        }
        if services[indexPath.row].status == 1 {
            cell.makeInactive()
        }else{
            cell.makeActive()
        }
        return cell
    }
    
  
    
}

//extension HomeVC: UIScrollViewDelegate{
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == mainView.collectionView{
//            UIView.animate(withDuration: 0.5){
//                self.mainView.floatingBtn.isHidden = scrollView.contentOffset.y > 50
//            }
//        }
//
//        let screenSize = self.mainView.collectionView.contentSize
////        self.mainView.floatingBtn
//
//        var factor: CGFloat = 1.0
//        factor = scrollView.contentOffset.y / screenSize.height
//        if factor > 1
//        {
//            factor = 2 - factor
//        }
//        print(factor)
//        //This will change the size
//        let timeOffset = CFTimeInterval(factor)
//        if factor > 0 {
//            self.mainView.floatingBtn.layer.timeOffset = timeOffset
//        }
//
//
//    }
//
//    func setupButtonAnimation()
//           {
//               let animation = CABasicAnimation.init(keyPath: "transform.scale")
//               animation.fromValue = 1.0
//               animation.toValue = 0.0
//               animation.duration = 1.0
//               //Set the speed of the layer to 0 so it doesn't animate until we tell it to
//               self.mainView.floatingBtn.layer.speed = 0.0;
//               self.mainView.floatingBtn.layer.add(animation, forKey: "transform");
//           }
//}


//MARK: - Api Reguests
extension HomeVC {
    func getAllBanners() {
        HomeRequests.shared.getAllBanners().subscribe { res in
            if res.data != nil {
                self.banners = res.data ?? []
                self.getAllNews()
            }
        } onFailure: { _ in
            self.mainView.showNoConnection()
        }.disposed(by: disposeBag)
    }
    
    func getAllNews() {
        HomeRequests.shared.getAllServices().subscribe { res in
            if res.data != nil {
                self.services = res.data ?? []
                self.banners.forEach { banner in
                    self.images.append(banner.imagePath ?? "")
                }
                self.mainView.showData()
                self.mainView.collectionView.reloadData()
            }else{
                self.mainView.showNoContent()
            }
        } onFailure: { _ in
            self.mainView.showNoConnection()
        }.disposed(by: disposeBag)
    }
    
}

extension HomeVC: ActionPopupProtocol {
    func action(isTrue: Bool, indexPath: IndexPath) {
        let vc = CreateOrderVC()
        vc.total_price = self.services[indexPath.row].total_price ?? 0
        vc.service_price = self.services[indexPath.row].service_price ?? 0
        vc.serviceID = self.services[indexPath.row].uuid ?? ""
        vc.userCredentialsSet = isTrue
        vc.defaultLoaderCountForService = self.services[indexPath.row].default_employee_count ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
