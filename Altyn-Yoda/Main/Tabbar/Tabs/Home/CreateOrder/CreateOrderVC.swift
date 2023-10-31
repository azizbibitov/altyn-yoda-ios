//
//  CreateOrderVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 08.04.2023.
//

import UIKit
import EasyPeasy
import Alamofire
import RxSwift
import CoreLocation
import BSImagePicker
import Photos

class CreateOrderVC: UIViewController {
    
    var userCredentialsSet: Bool = false
    
    var images: [UIImage] = []
    var imagesEmpty: Bool = false
    
    var sides: [PaymentSide] = [
        PaymentSide(title: "sender".localized(), status: 0),
        PaymentSide(title: "receiver".localized(), status: 1),
    ]
    
    var defaultLoaderCountForService: Int = 0
    
    let imageRequestOptions: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .highQualityFormat
        option.version = .current
        option.resizeMode = .exact
        option.isSynchronous = false
        return option
    }()
    
    var total_price: Int = 0
    var service_price: Int = 0
    
    var byWho: Int = 0
    var whoPay: Int = 0
    
    var serviceID: String = ""
    lazy var disposeBag = DisposeBag()
    var coordinateWhereFrom: CLLocationCoordinate2D?
    var coordinateWhereTo: CLLocationCoordinate2D?
    var rates: [Rate] = []
    
    var orderModel: Order!
    
    var requestsCount: Int = 0
    
    var mainView: CreateOrderView {
        return view as! CreateOrderView
    }
    
    override func loadView() {
        super.loadView()
        view = CreateOrderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCallbacks()
        setupKeyboardManager()
        mainView.photosHorizontalCollection.delegate = self
        mainView.photosHorizontalCollection.dataSource = self
        
        mainView.byWhoDownTable.delegate = self
        mainView.byWhoDownTable.dataSource = self
        
        mainView.whoPayDropDownTable.delegate = self
        mainView.whoPayDropDownTable.dataSource = self
        
        getRates(serviceID: self.serviceID)
        mainView.showLoading()
        
        mainView.delegate = self
        mainView.packageChoice.choiceView.calculatePriceDelegate = self
        mainView.senderPhoneTextField.textField.delegate = self
        mainView.receiverPhoneTextField.textField.delegate = self
        
        if userCredentialsSet {
            setupUserDefaults()
        }
        
        mainView.techInspection.techInspectionHour.textField.text = getCurrentTime()
        mainView.techInspection.techInspectionDate.textField.text = getCurrentDate()
        mainView.quantity.textField.text = "\(defaultLoaderCountForService)"
    }
    
    func setupUserDefaults(){
        mainView.senderName.textField.text = AccountUserDefaults.shared.getUser().username
        mainView.senderPhoneTextField.textField.text = String(AccountUserDefaults.shared.getUser().phone.dropFirst(4))
        mainView.locationDefiner.whereFromDefinerView.textField.text = AccountUserDefaults.shared.getUser().address
        let location = AccountUserDefaults.shared.getUser().location
        let coordinates = location.components(separatedBy: "x")
        if location != "" {
            mainView.locationDefiner.whereFromDefinerView.locationId.text = coordinates.first// lat
            mainView.locationDefiner.whereFromDefinerView.locationAdded()
            coordinateWhereFrom = CLLocationCoordinate2D(latitude: Double(coordinates.first ?? "0.0") ?? 0.0, longitude: Double(coordinates.last ?? "0.0") ?? 0.0)
        }
    }
    
    func getCurrentTime() -> String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        let dateString = df.string(from: date)
        return dateString
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateString = df.string(from: date)
        return dateString
    }
    
    
    func makeOrder(){
        print("0")
        
        if mainView.checkIfFieldsEmpty() {
            self.mainView.acceptButton.isUserInteractionEnabled = true
            self.mainView.showData()
            PopUpLancher.showWarningMessage(text: "fill_all_required_info".localized())
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            return
        }
        
        if images.count == 0 {
            imagesEmpty = true
            mainView.photosHorizontalCollection.reloadData()
            self.mainView.acceptButton.isUserInteractionEnabled = true
            self.mainView.showData()
            PopUpLancher.showWarningMessage(text: "add_images".localized())
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            return
        }else{
            imagesEmpty = false
        }
        
        
        if mainView.loaderChoice.choiceView.choice == 1 {
            if mainView.quantity.textField.text == "" {
                PopUpLancher.showWarningMessage(text: "fill_all_required_info".localized())
                self.mainView.acceptButton.isUserInteractionEnabled = true
                self.mainView.showData()
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                return
            }
        }
//        print("2")
        if mainView.sizeChoice.choiceView.choice == 0 {
            if mainView.selectedRateIndex == -1 {
                PopUpLancher.showWarningMessage(text: "choose_rate".localized())
                self.mainView.acceptButton.isUserInteractionEnabled = true
                self.mainView.showData()
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                return
            }
        }else{
            if mainView.exactSize.weightField.textField.text == "" || mainView.exactSize.widthTextField.textField.text == "" || mainView.exactSize.lengthTextField.textField.text == "" || mainView.exactSize.heightTextField.textField.text == ""{
                PopUpLancher.showWarningMessage(text: "fill_all_required_info".localized())
                self.mainView.acceptButton.isUserInteractionEnabled = true
                self.mainView.showData()
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                return
            }
        }
        print("3")
        // MARK: TODO
        //Surat ucin additdional Barlag
        
        
        //-----------------------------
        
        self.orderModel = Order()
        orderModel.uuid = ""
        orderModel.service_id = serviceID
        orderModel.address_from = mainView.locationDefiner.whereFromDefinerView.textField.text
        orderModel.address_to = mainView.locationDefiner.whereToDefinerView.textField.text
        orderModel.date = mainView.techInspection.techInspectionDate.textField.text
        orderModel.hour = mainView.techInspection.techInspectionHour.textField.text
        orderModel.description = mainView.descriptionMultilineTextField.multilineTextField.text
        
        orderModel.size = mainView.sizeChoice.choiceView.choice
        
        var weight: Int?
        var width: Int?
        var height: Int?
        var length: Int?
        
        if mainView.sizeChoice.choiceView.choice == 0 {
            weight = self.rates[mainView.selectedRateIndex].weight
            width = self.rates[mainView.selectedRateIndex].with
            height = self.rates[mainView.selectedRateIndex].height
            length = self.rates[mainView.selectedRateIndex].length
        }else{
            weight = Int(self.mainView.exactSize.weightField.textField.text ?? "0")
            width = Int(self.mainView.exactSize.widthTextField.textField.text ?? "0")
            height = Int(self.mainView.exactSize.heightTextField.textField.text ?? "0")
            length = Int(self.mainView.exactSize.lengthTextField.textField.text ?? "0")
        }
        
        orderModel.weight = weight
        orderModel.width = width
        orderModel.height = height
        orderModel.length = length
        orderModel.loader = mainView.loaderChoice.choiceView.choice
        if mainView.loaderChoice.choiceView.choice == 1 {
            orderModel.quantity = Int(mainView.quantity.textField.text ?? "0")
        }
        
        orderModel.package = mainView.packageChoice.choiceView.choice
        orderModel.floor = mainView.floorChoice.choiceView.choice
        orderModel.wait_sender = mainView.waitForSenderChoice.choiceView.choice
        orderModel.wait_recipient = mainView.waitForReceiverChoice.choiceView.choice
        orderModel.sender = mainView.senderName.textField.text
        orderModel.sender_phone_number = mainView.senderPhoneTextField.textField.text
        orderModel.recipient = mainView.receiverName.textField.text
        orderModel.recipient_phone_number = mainView.receiverPhoneTextField.textField.text
        
        if mainView.packageChoice.choiceView.choice == 0 {
            orderModel.price = self.service_price
        }else{
            orderModel.price = self.total_price
        }
        
        orderModel.status = 0
        
        if coordinateWhereFrom != nil {
            orderModel.map_from = "\(coordinateWhereFrom?.latitude ?? 0.0)x\(coordinateWhereFrom?.longitude ?? 0.0)"
        }
        
        if coordinateWhereTo != nil {
            orderModel.map_to = "\(coordinateWhereTo?.latitude ?? 0.0)x\(coordinateWhereTo?.longitude ?? 0.0)"
        }
        
        orderModel.by_who = self.byWho
        orderModel.who_pay = self.whoPay
        
        
        orderModel.client_id = AccountUserDefaults.shared.getUser().uuid
        if mainView.sizeChoice.choiceView.choice == 0 {
            self.orderModel.rate_id = self.rates[mainView.selectedRateIndex].uuid
        }
        
        print("upsertOrder")
        self.upsertOrder(order: self.orderModel)
    }
    
    
    func setupCallbacks(){
        mainView.header.backBtnClickCallback = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        mainView.header.customBtnClickCallback = { [weak self] in
            print("ArticleNotification")
            
        }
        
//        mainView.techInspection.techInspectionDate.innerBtnClickedCallBack = { [weak self] in
//            print("techInspectionDateInner")
//            self!.mainView.techInspection.techInspectionHour.endEditing(true)
//        }
//        
//        mainView.techInspection.techInspectionHour.innerBtnClickedCallBack = { [weak self] in
//            print("techInspectionHourInner")
//            self!.mainView.techInspection.techInspectionDate.endEditing(true)
//        }
        
        mainView.locationDefiner.whereToDefinerView.innerBtnClickCallback = { [weak self] in
            print("innerBtnClickCallback")
            let mapVC = DefineLocationOnMapVC()
            mapVC.modalPresentationStyle = .fullScreen
            mapVC.locationDelegate = self
            mapVC.where_from = false
            self?.navigationController?.pushViewController(mapVC, animated: true)
        }
        
        mainView.locationDefiner.whereFromDefinerView.innerBtnClickCallback = { [weak self] in
            print("innerBtnClickCallback")
            let mapVC = DefineLocationOnMapVC()
            mapVC.modalPresentationStyle = .fullScreen
            mapVC.locationDelegate = self
            mapVC.where_from = true
            self?.navigationController?.pushViewController(mapVC, animated: true)
        }
        
        
        mainView.fromWhomDropDownCallback = { [weak self] in
            print("showDistrictDropDownCallback")
            self?.addFromWhomTransparentView(frames: self!.mainView.byWhoDropDown.frame)
        }
        
        mainView.whoPayDropDownCallback = { [weak self] in
            print("showCityDropDownCallback")
            self?.addWhoPayTransparentView(frames: self!.mainView.whoPayDropDown.frame)
        }
        
        mainView.acceptClickCallback = { [weak self] in
            print("acceptClickCallback")
            self!.mainView.showLoadingOnly()
            self!.mainView.acceptButton.isUserInteractionEnabled = false
            self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self?.makeOrder()
        }
        
        mainView.sizeChoice.choiceView.yesClickCallback = { [weak self] in
            print("sizeChoiceYes")
            //            self?.mainView.photosHorizontalCollection.isHidden = true
            //            self?.mainView.photosHorizontalCollection.easy.layout(Height(0))
            //            self?.mainView.photosLabel.isHidden = true
            self?.mainView.exactSize.isHidden = false
            self?.mainView.packagesWrapper.isHidden = true
        }
        
        mainView.sizeChoice.choiceView.noClickCallback = { [weak self] in
            print("sizeChoiceNo")
            self?.mainView.exactSize.isHidden = true
            self?.mainView.packagesWrapper.isHidden = false
        }
        
        mainView.loaderChoice.choiceView.yesClickCallback = { [weak self] in
            print("loaderChoiceYes")
            self?.mainView.quantity.isHidden = false
        }
        
        mainView.loaderChoice.choiceView.noClickCallback = { [weak self] in
            print("loaderChoiceNo")
            self?.mainView.quantity.isHidden = true
        }
        
        mainView.noConnection.clickCallback = { [weak self] in
            self!.getRates(serviceID: self!.serviceID)
            self!.mainView.showLoading()
        }
    }
    
    func setupKeyboardManager(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        
        mainView.scrollView.contentInset = contentInsets
        mainView.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        mainView.scrollView.contentInset = contentInsets
        mainView.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        // go through all of the textfield inside the view, and end editing thus resigning first responder
        // ie. it will trigger a keyboardWillHide notification
        self.view.endEditing(true)
    }
    
    
    
    
}

extension CreateOrderVC: AddLocationProtocol {
    func giveLocation(coordinate: CLLocationCoordinate2D, where_from: Bool) {
        if where_from {
            self.coordinateWhereFrom = coordinate
            print("coordinate?.longitude", self.coordinateWhereFrom!.longitude)
            print("coordinate?.latitude", self.coordinateWhereFrom!.latitude)
            mainView.locationDefiner.whereFromDefinerView.locationId.text = "\(coordinate.longitude )"
            mainView.locationDefiner.whereFromDefinerView.locationAdded()
        }else{
            self.coordinateWhereTo = coordinate
            print("coordinate?.longitude", self.coordinateWhereTo!.longitude)
            print("coordinate?.latitude", self.coordinateWhereTo!.latitude)
            mainView.locationDefiner.whereToDefinerView.locationId.text = "\(coordinate.longitude )"
            mainView.locationDefiner.whereToDefinerView.locationAdded()
        }
        
    }
    
}

extension CreateOrderVC: ChooseRateProtocol {
    func clearValues() {
        if mainView.packageChoice.choiceView.choice == 0 {
            mainView.priceField.textField.text = "\(service_price)"
        }else{
            mainView.priceField.textField.text = "\(total_price)"
        }
    }
}

extension CreateOrderVC: PackageChoiceProtocol {
    func calculatePrice() {
        if mainView.packageChoice.choiceView.choice == 0 {
            mainView.priceField.textField.text = "\(service_price)"
        }else{
            mainView.priceField.textField.text = "\(total_price)"
        }
    }
}

extension CreateOrderVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location == 8 { return false }
        switch textField.text!.count + range.length {
        case 0:  return string == "6"
        case 1:  return (string > "0") && (string < "6")
        default: return string == string.filter("0123456789".contains)
        }
    }
}

extension CreateOrderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCollectionCell.identifier, for: indexPath) as! AddPhotoCollectionCell
            if self.imagesEmpty {
                cell.showItsEmpty()
            }else{
                cell.showItsNotEmpty()
            }
            cell.clickCallback = { [weak self] in
                print("addImageClick")
                let imagePicker = ImagePickerController()
                self?.presentImagePicker(imagePicker, select: { (asset) in
                    print("select")
                    // User selected an asset. Do something with it. Perhaps begin processing/upload?
                }, deselect: { (asset) in
                    print("deselect")
                    // User deselected an asset. Cancel whatever you did when asset was selected.
                }, cancel: { (assets) in
                    print("cancel")
                    // User canceled selection.
                }, finish: { (assets) in
                    print("finish")
                    print("assetsX: ", assets)
                    
                    self?.imagesEmpty = assets.isEmpty
                    
                    assets.forEach { asset in
                        DispatchQueue.global(qos: .userInitiated).async {
                            let size = CGSizeMake(400, 400)
                            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: self!.imageRequestOptions) { (image, info) in
                                if let image = image {
                                    self?.images.insert(image, at: 0)
                                    collectionView.reloadData()
                                }
                            }
                        }
                    }
                    
                    
                    
                })
            }
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosHorizontalCollectionCell.identifier, for: indexPath) as! PhotosHorizontalCollectionCell
            
            cell.setImage(image: images[indexPath.item-1])
            cell.clickCallback = { [weak self] in
                print("deleteImageClick")
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                    self!.images.remove(at: indexPath.item-1)
                    collectionView.reloadData()
                }, completion: nil)
            }
            
            cell.itemClickCallback = { [weak self] in
                print("itemClickCallback")
                let vc = PhotosVC()
                vc.modalPresentationStyle = .fullScreen
                vc.mainView.configure(images: self!.images)
                vc.mainView.forUIImages = true
                vc.mainView.setupScrollView()
                vc.selectedImageIndex = indexPath.row-1
                vc.indexPathScrollTo = IndexPath(row: indexPath.row-1, section: 0)
                self!.present(vc, animated: true, completion: nil)
            }
            
            return cell
        }
        
        
        
    }
    
  
    
}


//MARK: - CityDropDownFunctionality
extension CreateOrderVC {
    func addFromWhomTransparentView(frames: CGRect) {
        mainView.byWhoDownTable.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeCityTransparentViewTapped))
        mainView.byWhoTransparentView.addGestureRecognizer(tapgesture)
        mainView.byWhoTransparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.mainView.byWhoTransparentView.alpha = 0.5
            self.mainView.showCityDropDown(numberOfItems: Double(self.sides.count))
        }, completion: nil)
    }
    
    @objc func removeCityTransparentViewTapped() {
        removeTransparentView()
    }
    
    func removeTransparentView(){
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.mainView.byWhoTransparentView.alpha = 0
            self.mainView.hideCityDropDown()
        }, completion: nil)
    }
}


//MARK: - DistrictDropDownFunctionality
extension CreateOrderVC {
    func addWhoPayTransparentView(frames: CGRect) {
        mainView.whoPayDropDownTable.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeDistrictTransparentViewTapped))
        mainView.whoPayTransparentView.addGestureRecognizer(tapgesture)
        mainView.whoPayTransparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.mainView.whoPayTransparentView.alpha = 0.5
            self.mainView.showDistrictDropDown(numberOfItems: Double(self.sides.count))
            
        }, completion: nil)
    }
    
    @objc func removeDistrictTransparentViewTapped() {
        removeDistrictTransparentView()
    }
    
    func removeDistrictTransparentView(){
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.mainView.whoPayTransparentView.alpha = 0
            self.mainView.hideDistrictDropDown()
        }, completion: nil)
    }
}


//MARK: - UITableViewDelegates
extension CreateOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == mainView.byWhoDownTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTableCell.identifier, for: indexPath) as! DropDownTableCell
            
            cell.lbl.text = sides[indexPath.row].title
            cell.lbl.font = .interRegular(size: 14)
            cell.clickCallback = { [weak self] in
                print("clickCallback")
                self?.mainView.byWhoDropDown.dropBtn.setTitle(self?.sides[indexPath.row].title, for: .normal)
                self?.byWho = self!.sides[indexPath.row].status
                self?.removeCityTransparentViewTapped()
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTableCell.identifier, for: indexPath) as! DropDownTableCell
            
            cell.lbl.text = sides[indexPath.row].title
            
            cell.clickCallback = { [weak self] in
                print("clickCallback")
                self?.mainView.whoPayDropDown.dropBtn.setTitle(self?.sides[indexPath.row].title, for: .normal)
                self?.whoPay = self!.sides[indexPath.row].status
                self?.removeDistrictTransparentViewTapped()
            }
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == mainView.byWhoDownTable {
            mainView.byWhoDropDown.dropBtn.setTitle(sides[indexPath.row].title, for: .normal)
            self.byWho = sides[indexPath.row].status
            removeCityTransparentViewTapped()
        }else{
            mainView.whoPayDropDown.dropBtn.setTitle(sides[indexPath.row].title, for: .normal)
            self.whoPay = sides[indexPath.row].status
            removeDistrictTransparentViewTapped()
        }
        
        
        print("setTitle")
    }
    
}

//MARK: - Api Reguests
extension CreateOrderVC {
    func uploadImage(image: Data?, orderID: String){
        
        let header: HTTPHeaders = [ "Authorization": AccountUserDefaults.shared.getUser().token ]
        guard let imageData = image else { return }
        AF.upload(multipartFormData: { formData in
            
            formData.append(imageData, withName: "file", fileName: imageData.description)
            
        }, to: ApiUrl.shared.SAMPLE_URL, headers: header).responseDecodable(of: UploadImageResponse.self) { response in
            debugPrint(response)
            let successResponse = response.value
            if response.error != nil || successResponse?.status == nil {
                //                self.mainView.isUserInteractionEnabled = true
//                PopUpLancher.showErrorMessage(text: "smth_went_wrong".localized())
                self.mainView.acceptButton.isUserInteractionEnabled = true
                self.mainView.dismissLoading()
                return
            }
            
            if !(successResponse?.status ?? false) {
                //                self.mainView.isUserInteractionEnabled = true
                ErrorCodes.shared.showErrorMessage(errorCode: successResponse?.code)
                self.mainView.acceptButton.isUserInteractionEnabled = true
                self.mainView.dismissLoading()
                return
            }
            
            // Indiki Request...
            if successResponse?.data != nil {
                self.addOrderImages(orderID: orderID, uploadedImagePath: successResponse!.data!)
            }
            
        }
    }
    
    func getDataFromAsset(asset: PHAsset?, completionHandler: @escaping (Data?)->Void ) {
        guard let phAsset = asset else { return }
   
            PHImageManager.default().requestImageData(for: phAsset, options: imageRequestOptions) { data, _, _, info in
                if info?["PHImageResultIsInCloudKey"] as? Int? == 1 {
                    completionHandler(nil)
                    return
                }
                
                completionHandler(data)
            }
          
    }
    
    func getRates(serviceID: String) {
        OrderRequests.shared.getAllRatesByServiceID(serviceID: serviceID).subscribe { res in
            if res.data != nil {
                
                self.rates = res.data ?? []
                self.mainView.setupStackViews(rates: res.data ?? [])
                
                self.mainView.loaderChoice.choiceView.yesClick()
                self.mainView.packageChoice.choiceView.yesClick()
                self.mainView.floorChoice.choiceView.yesClick()
                self.mainView.waitForSenderChoice.choiceView.yesClick()
                self.mainView.waitForReceiverChoice.choiceView.yesClick()
                self.mainView.waitForSenderChoice.choiceView.yesClick()
                
                
                self.mainView.showData()
                
            }else{
                
            }
            
        } onFailure: { _ in
            self.mainView.showNoConnection()
        }.disposed(by: disposeBag)
    }
    
    func upsertOrder(order: Order) {
        OrderRequests.shared.upsertOrder(model: order).subscribe { res in
            if res.data != nil {
                // Indiki Request...
                
                self.images.forEach { image in
                    let data = image.jpegData(compressionQuality: 0.5)
                    self.uploadImage(image: data, orderID: res.data!.uuid!)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if let window = UIApplication.shared.windows.first {
                        let vc = StateScreenVC()
                        window.rootViewController = vc
                        window.makeKeyAndVisible()
                        UIView.transition(with: window, duration: 0.4, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                    }
                }
            }else{
                //Error
            }
            
        } onFailure: { _ in
            self.mainView.acceptButton.isUserInteractionEnabled = true
            self.mainView.dismissLoading()
        }.disposed(by: disposeBag)
    }
    
    func addOrderImages(orderID: String, uploadedImagePath: String){
        OrderRequests.shared.addOrderImages(order_id: orderID, image_path: uploadedImagePath).subscribe { res in
            
        } onFailure: { _ in
            self.mainView.acceptButton.isUserInteractionEnabled = true
            self.mainView.dismissLoading()
        }.disposed(by: disposeBag)
    }
    
    
}


