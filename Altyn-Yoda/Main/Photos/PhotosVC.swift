//
//  PhotosVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 22.04.2023.
//

import UIKit
import EasyPeasy
import CloudKit
import Alamofire
import Kingfisher

class PhotosVC: UIViewController {
    
    var selectedImageIndex = 0
    var indexPathScrollTo: IndexPath = IndexPath(row: 0, section: 0)
    
    var mainView: PhotosView {
        return view as! PhotosView
    }

    override func loadView() {
        super.loadView()
        
        view = PhotosView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.showLoading()
        
        mainView.backImage2Callback = { [weak self] in
            print("backImage2Tapped")
            self?.dismiss(animated: true)
        }

        mainView.nextClickCallback = { [weak self] in
            print("nextClickCallback")
            
            if self!.selectedImageIndex != (self!.mainView.collectionView.numberOfItems(inSection: 0)-1) {
                let indexPathFrom = IndexPath(row: self!.selectedImageIndex, section: 0)
                self!.selectedImageIndex += 1
                let indexPathTo = IndexPath(row: self!.selectedImageIndex, section: 0)
                self!.mainView.collectionView.scrollToItem(at: indexPathTo, at: .centeredHorizontally, animated: true)
                let x = CGFloat(self!.selectedImageIndex) * self!.mainView.width!
                self!.mainView.imagesScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
                self!.mainView.collectionView.reloadItems(at: [indexPathFrom, indexPathTo])
            }
        }
        
        mainView.prevClickCallback = { [weak self] in
            print("prevClickCallback")
            if self!.selectedImageIndex != 0 {
                let indexPathFrom = IndexPath(row: self!.selectedImageIndex, section: 0)
                self!.selectedImageIndex -= 1
                let indexPathTo = IndexPath(row: self!.selectedImageIndex, section: 0)
                self!.mainView.collectionView.scrollToItem(at: indexPathTo, at: .centeredHorizontally, animated: true)
                let x = CGFloat(self!.selectedImageIndex) * self!.mainView.width!
                self!.mainView.imagesScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
                self!.mainView.collectionView.reloadItems(at: [indexPathFrom, indexPathTo])
            }
        }
        
        view.backgroundColor = .whiteBlackColor
        navigationController?.navigationBar.isHidden = true
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        mainView.imagesScrollView.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            let indexPathFrom = NSIndexPath(row: self.selectedImageIndex, section: 0) as IndexPath
            if let cell = self.mainView.collectionView.cellForItem(at: indexPathFrom) as? ArticleCollectionViewCell{
                cell.isSelected = false
            }
            
            let x = CGFloat(self.indexPathScrollTo.item) * self.mainView.width!
            self.mainView.imagesScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
            self.mainView.collectionView.scrollToItem(at: self.indexPathScrollTo, at: .centeredHorizontally, animated: true)
            
            if let cell = self.mainView.collectionView.cellForItem(at: self.indexPathScrollTo) as? ArticleCollectionViewCell{
                cell.isSelected = true
                self.selectedImageIndex = self.indexPathScrollTo.row
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.mainView.dismissLoading()
            }
        }
        
        
        
    }
    
  

}

extension PhotosVC: UIScrollViewDelegate {
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == mainView.imagesScrollView {
            
            let indexPathFrom = IndexPath(row: selectedImageIndex, section: 0)
            
            
            if selectedImageIndex != scrollView.currentPage - 1{
                
                selectedImageIndex = scrollView.currentPage - 1
                let indexPathTo = IndexPath(row: selectedImageIndex, section: 0)
                mainView.collectionView.reloadItems(at: [indexPathFrom, indexPathTo])
                mainView.collectionView.scrollToItem(at: indexPathTo, at: .centeredHorizontally, animated: true)
            }
            
        }
    }
    
}

extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.mainView.forUIImages {
            return mainView.imagesUIImage.count
        }else{
            return mainView.images.count
        }
     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleViewCell", for: indexPath) as! ArticleCollectionViewCell
        
        if self.mainView.forUIImages {
            cell.image1.image = mainView.imagesUIImage[indexPath.item]
        }else{
            let image_api_url = ApiUrl.shared.getPath(serverPath: mainView.images[indexPath.item])
            
            cell.image1.kf.setImage(with: image_api_url)
        }
       

        if(indexPath.row == self.selectedImageIndex) { //for first cell in the collection
            cell.image1.alpha = 1
        } else {
            cell.image1.alpha = 0.4
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let indexPathFrom = NSIndexPath(row: selectedImageIndex, section: 0) as IndexPath
        if let cell = collectionView.cellForItem(at: indexPathFrom) as? ArticleCollectionViewCell{
            cell.isSelected = false
        }
        
        let x = CGFloat(indexPath.item) * mainView.width!
        mainView.imagesScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ArticleCollectionViewCell{
            cell.isSelected = true
            selectedImageIndex = indexPath.row
        }

    }
    

}

