//
//  OrderVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 17.04.2023.
//

import UIKit
import RxSwift
import EasyPeasy

class OrderPageVC: UIViewController {
    
    lazy var disposeBag = DisposeBag()
    var order: Order!
    var orderID: String = ""
    var serviceID: String = ""
    var rateID: String?
    var rates: [Rate] = []
    
    var images: [String] = []
    
    var mainView: OrderPageView {
        return view as! OrderPageView
    }
    
    override func loadView() {
        super.loadView()
        view = OrderPageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCallbacks()
      
        
        getRates(serviceID: self.serviceID)
        mainView.showLoading()
        
        mainView.photosHorizontalCollection.delegate = self
        mainView.photosHorizontalCollection.dataSource = self
    }
    
    func configureOrderPage(){
        
        if order.size == 0 {
            mainView.sizeChoice.choiceView.noClick()
            mainView.exactSize.isHidden = true
            mainView.packagesWrapper.isHidden = false
        }else{
            mainView.sizeChoice.choiceView.yesClick()
            mainView.exactSize.isHidden = false
            mainView.packagesWrapper.isHidden = true
        }
        
        if order.loader == 0 {
            mainView.quantity.isHidden = true
        }else{
            mainView.quantity.isHidden = false
        }
        
        if order.status != 0 {
            mainView.cancelButton.isHidden = true
            mainView.cancelNoteLabel.isHidden = true
        }
        
    }
    
    func setupCallbacks(){
        mainView.header.backBtnClickCallback = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
  
        mainView.locationDefiner.whereFromDefinerView.innerBtnClickCallback = { [weak self] in
            print("whereFromDefinerView")
            let mapVC = ShowLocationOnMapVC()
            mapVC.modalPresentationStyle = .fullScreen
            mapVC.where_from = true
            mapVC.coordinates = self!.order.map_from ?? ""
            self?.navigationController?.pushViewController(mapVC, animated: true)
        }
        
        mainView.locationDefiner.whereToDefinerView.innerBtnClickCallback = { [weak self] in
            print("whereToDefinerView")
            let mapVC = ShowLocationOnMapVC()
            mapVC.modalPresentationStyle = .fullScreen
            mapVC.where_from = false
            mapVC.coordinates = self!.order.map_to ?? ""
            self?.navigationController?.pushViewController(mapVC, animated: true)
        }
        
        mainView.cancelClickCallback = { [weak self] in
            print("cancelClickCallback")
            
            let actionPopup = GoldenWayActionPopupVC(actionLabelText: "sure_to_cancel_order".localized(), yesActionText: "yes".localized(), noActionText: "no".localized())
            actionPopup.modalPresentationStyle  = .overFullScreen
            actionPopup.modalTransitionStyle    = .crossDissolve
            actionPopup.delegate = self
            self?.present(actionPopup, animated: true)
            
            
        }
       
        mainView.noConnection.clickCallback = { [weak self] in
            self!.getRates(serviceID: self!.serviceID)
            self!.mainView.showLoading()
        }
    }


}

extension OrderPageVC: ActionPopupProtocol {
    func action(isTrue: Bool, indexPath: IndexPath) {
        if isTrue {
            cancelOrder(orderID: orderID)
            mainView.showLoadingOnly()
        }
     
    }
    
}

extension OrderPageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosHorizontalCollectionCell.identifier, for: indexPath) as! PhotosHorizontalCollectionCell
        
        cell.setImage(image: images[indexPath.item])
        cell.itemClickCallback = { [weak self] in
            print("itemClickCallback")
            let vc = PhotosVC()
            vc.modalPresentationStyle = .fullScreen
            vc.mainView.configure(images: self!.images)
            vc.mainView.setupScrollView()
            vc.selectedImageIndex = indexPath.row
            vc.indexPathScrollTo = indexPath
            self!.present(vc, animated: true, completion: nil)
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("didSelectItemAt")
//        let vc = PhotosVC()
//        vc.modalPresentationStyle = .fullScreen
//        vc.mainView.configure(images: self.images)
//        vc.mainView.setupScrollView()
//        vc.selectedImageIndex = indexPath.row
//        vc.indexPathScrollTo = indexPath
//        self.present(vc, animated: true, completion: nil)
//    }
    
}



//MARK: - Api Reguests
extension OrderPageVC {
    
    func getRates(serviceID: String) {
        OrderRequests.shared.getAllRatesByServiceID(serviceID: serviceID).subscribe { res in
            if res.data != nil {
                
                self.rates = res.data ?? []
                let rate = self.rates.filter({$0.uuid == self.rateID})
                self.mainView.setupStackViews(rates: rate)
                self.mainView.setupOrderData(order: self.order)
                self.configureOrderPage()
                self.mainView.showData()
                self.getOrderImages(orderID: self.orderID)
            }else{
                
            }
            
        } onFailure: { _ in
            self.mainView.showNoConnection()
        }.disposed(by: disposeBag)
    }
    
    func getOrderImages(orderID: String){
        OrderRequests.shared.getOrderImages(orderID: orderID).subscribe { res in
            if res.data == nil || res.data?.count == 0 {
                self.mainView.photosLabel.isHidden = true
                self.mainView.photosHorizontalCollection.isHidden = true
                self.mainView.photosHorizontalCollection.easy.layout(Height(0))
            }else{
                res.data?.forEach({ orderImage in
                    self.images.append(orderImage.image_path ?? "")
                })
                self.mainView.photosHorizontalCollection.reloadData()
            }
        
        } onFailure: { _ in
            self.mainView.showNoConnection()
        }.disposed(by: disposeBag)
    }
    
    func cancelOrder(orderID: String) {
        OrderRequests.shared.cancelOrder(orderID: orderID).subscribe { res in
            
            self.mainView.dismissLoading()
            self.mainView.cancelButton.isHidden = true
            self.mainView.cancelNoteLabel.isHidden = true
            
        } onFailure: { _ in
            self.mainView.showNoConnection()
        }.disposed(by: disposeBag)
    }
    
}
