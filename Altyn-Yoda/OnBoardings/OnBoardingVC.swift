//
//  OnBoardingsVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 25.03.2023.
//

import UIKit
import EasyPeasy



class OnBoardingVC: UIViewController {
    
    var currentPage = 0
    
    var images: [String] = ["splash-1", "splash-2", "splash-3"]
    
    var titles: [String] = ["Ваш переезд - наша забота!", "Переезжайте без стресса с нами!", "Переезжайте быстро и безопасно с нами!"]
    var subTitles: [String] = ["Доверьте свой переезд профессионалам!", "Мы делаем переезд легким и приятным!", "Мы заботимся о каждой мелочи во время переезда!"]
    
    var mainView: OnBoardingView {
        return view as! OnBoardingView
    }
    
    override func loadView() {
        super.loadView()
        view = OnBoardingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mainView.images = images
        mainView.setupUI()
        mainView.setupPageControl(images: images)
        setupCollectionDelegateDatasource()

        setupCallbacks()
    }
    
    func setupCallbacks() {
        mainView.nextClickCallback = { [weak self] in
           
            
            if self!.currentPage == 3 {
                if let window = UIApplication.shared.windows.first {
                    
                    let vc = EnterPhoneNumberVC()
                    window.rootViewController = UINavigationController(rootViewController:  vc)
                    window.makeKeyAndVisible()
                    UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
            }else{
                var currentPage = self!.mainView.carouselCollection.currentPage
                
                if currentPage == self!.images.count {
    //                currentPage = 1
                }else{
                    currentPage += 1
                }
                self?.mainView.carouselCollection.scrollToCell(at: currentPage-1, animated: true)
            }
        }
        
        mainView.skipClickCallback = { [weak self] in
            
            self?.mainView.carouselCollection.scrollToCell(at: 2, animated: true)
        }
    }
    
    func makeNextBtnAuth(){
        self.mainView.skipBtn.isHidden = true
        self.mainView.nextBtn.btnInIcon.isHidden = true
        self.mainView.nextBtn.setTitle("sign_in".localized(), for: .normal)
        self.mainView.nextBtn.easy.layout(Width(140))
    }
    
    func makeAuthBtnNext(){
        self.mainView.skipBtn.isHidden = false
        self.mainView.nextBtn.easy.layout(Width(50))
        self.mainView.nextBtn.setTitle("", for: .normal)
        self.mainView.nextBtn.btnInIcon.isHidden = false
    }
    
    
    func setupCollectionDelegateDatasource(){
        mainView.carouselCollection.delegate = self
        mainView.carouselCollection.dataSource = self
        mainView.carouselCollection.reloadData()
    }


}

extension OnBoardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return images.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier, for: indexPath) as! CarouselCell
        cell.image.backgroundColor = .clear
        cell.image.image = UIImage(named: images[indexPath.row])
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        UIApplication.shared.open(NSURL(string: images[indexPath.item].target ?? "")! as URL)
//    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width

        mainView.pageControl.setPageOffset(offSet / width)
        
        if self.currentPage != self.mainView.carouselCollection.currentPage {
            self.currentPage = self.mainView.carouselCollection.currentPage
            print(currentPage)
            self.mainView.title.text = titles[currentPage-1]
            self.mainView.subTitle.text = subTitles[currentPage-1]
            
            if currentPage == 3 {
                self.makeNextBtnAuth()
            }else{
                self.makeAuthBtnNext()
            }
        }
        
    }
}
