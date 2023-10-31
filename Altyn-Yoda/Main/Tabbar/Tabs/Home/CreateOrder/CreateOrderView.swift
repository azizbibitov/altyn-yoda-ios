//
//  CreateOrderView.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 08.04.2023.
//

import UIKit
import EasyPeasy

class CreateOrderView: UIView {
    
    lazy var noConnection = NoconnectionView()
    lazy var noContent = NoContent()
    
    var packagesCellArray: [PackagesCell] = []
    var selectedRateIndex: Int = -1
    
    var delegate: ChooseRateProtocol?
    var showRateDescriptionDelegate: ShowRateDesctriptionProtocol?
    
    let header = HeaderWithBackBtn()
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .whiteBlackColor
        return scrollView
    }()
    
    lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.color = .primaryColor
        loading.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        return loading
    }()
    
    var loadingTransparent: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBlackColor?.withAlphaComponent(0.3)
        return view
    }()
    
    var collectionTopStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 20
        return stack
    }()
    
    var collectionBottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 20
        return stack
    }()
    
    let bottomSpace = UIView(frame: .zero)
    
    let addInfoLabel = GoldenWayLabel(font: .interSemiBold(size: 20), color: UIColor.textColor, alignment: .left, text: "add_info".localized())
    
    let locationDefiner = LocationDefinerView()
    
    let techInspection = TechInspectionView()
    
    let sizeChoice = ChoiceViewWithTopLbl(lbl: "size_choice".localized(), yesChoiceLblText: "exactly".localized(), noChoiceLblText: "approximately".localized())
    
    var packagesWrapper = UIView()
    var packagesStackView: UIStackView = {
       let st = UIStackView()
        st.axis = .vertical
        st.spacing = 8
        st.alignment = .fill
        return st
    }()
    
    var descriptionMultilineTextField: MultilineTextFieldWithTopLabel = {
        let field = MultilineTextFieldWithTopLabel(lbl: "description".localized())
//        field.textField.sidePadding = 12
        field.label.font = .interSemiBold(size: 12)
//        field.textField.easy.layout(Height(28))
        field.spacing = 2
        field.multilineTextField.font = .interRegular(size: 14)
        field.multilineTextField.layer.borderWidth = 1
        field.multilineTextField.layer.borderColor = UIColor.textColor?.cgColor
        field.multilineTextField.layer.cornerRadius = 6
        return field
    }()
    
    let photosLabel = GoldenWayLabel(font: .interSemiBold(size: 20), color: UIColor.textColor, alignment: .left, text: "photos".localized())
    
    lazy var photosHorizontalCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 14
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PhotosHorizontalCollectionCell.self, forCellWithReuseIdentifier: PhotosHorizontalCollectionCell.identifier)
        cv.register(AddPhotoCollectionCell.self, forCellWithReuseIdentifier: AddPhotoCollectionCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        cv.isScrollEnabled = true
        cv.backgroundColor = UIColor.photoCollectionColor
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -12)
        return cv
    }()
    
    let exactSize = ExactSizeDefineView()
    
    let loaderChoice = ChoiceViewWithTopLbl(lbl: "loader".localized(), yesChoiceLblText: "yes".localized(), noChoiceLblText: "no".localized())
    
    var quantity = CustomTextField(lbl: "quantity".localized(), pl: "")
    
    let packageChoice = ChoiceViewWithTopLbl(lbl: "package".localized(), yesChoiceLblText: "yes".localized(), noChoiceLblText: "no".localized())
    
    let floorChoice = ChoiceViewWithTopLbl(lbl: "floor".localized(), yesChoiceLblText: "yes".localized(), noChoiceLblText: "no".localized())
    
    let waitForSenderChoice = ChoiceViewWithTopLbl(lbl: "wait_for_sender".localized(), yesChoiceLblText: "yes".localized(), noChoiceLblText: "no".localized())
    
    let waitForReceiverChoice = ChoiceViewWithTopLbl(lbl: "wait_for_receiver".localized(), yesChoiceLblText: "yes".localized(), noChoiceLblText: "no".localized())
    
    let oformleniyeChooseLabel = GoldenWayLabel(font: .interSemiBold(size: 20), color: UIColor.textColor, alignment: .left, text: "oformleniye_wybor".localized())
    
    var byWhoDropDown = DropDownWithTopLabel(lbl: "by_who".localized(), pl: "sender".localized())
    let byWhoTransparentView = UIView()
    let byWhoDownTable = UITableView()
    
    var whoPayDropDown = DropDownWithTopLabel(lbl: "who_pay".localized(), pl: "sender".localized())
    let whoPayTransparentView = UIView()
    let whoPayDropDownTable = UITableView()
    
    let senderInfoLabel = GoldenWayLabel(font: .interSemiBold(size: 20), color: UIColor.textColor, alignment: .left, text: "sender_info".localized())
    
    var senderName = CustomTextField(lbl: "sender".localized(), pl: "")
    
    var senderPhoneText = UILabel(text: "  +993", font: .interRegular(size: 14), align: .right)
    var senderPhoneTextField = CustomTextField(lbl: "number".localized(), pl: "")
    
    let receiverInfoLabel = GoldenWayLabel(font: .interSemiBold(size: 20), color: UIColor.textColor, alignment: .left, text: "receiver_info".localized())
    
    var receiverName = CustomTextField(lbl: "receiver".localized(), pl: "")
    
    var receiverPhoneText = UILabel(text: "  +993", font: .interRegular(size: 14), align: .right)
    var receiverPhoneTextField = CustomTextField(lbl: "number".localized(), pl: "")
    
    
    let totalSumLabel = GoldenWayLabel(font: .interSemiBold(size: 20), color: UIColor.textColor, alignment: .left, text: "total_sum".localized())
    
    var currencyLabel = UILabel(text: "TMT   ", font: .interSemiBold(size: 16), align: .left)
    
    var priceField: CustomTextField = {
        let field = CustomTextField(lbl: "price".localized(), pl: "")
        field.textField.isEnabled = false
        return field
    }()
    
    let acceptButton = Button(title: "accept".localized())
   
    var fromWhomDropDownCallback: ( ()->Void )?
    var whoPayDropDownCallback: ( ()->Void )?
    
    var acceptClickCallback: ( ()->Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteBlackColor
        header.titleLabel.text = "create_order".localized()
        
        setupUI()
        addTargets()
    }
    
    func addTargets(){
        byWhoDropDown.dropBtn.addTarget(self, action: #selector(fromWhomDropDownTap), for: .touchUpInside)
        whoPayDropDown.dropBtn.addTarget(self, action: #selector(whoPayDropDownTap), for: .touchUpInside)
        
        acceptButton.addTarget(self, action: #selector(acceptBtnTap), for: .touchUpInside)
        
        byWhoDownTable.register(DropDownTableCell.self, forCellReuseIdentifier: DropDownTableCell.identifier)
        whoPayDropDownTable.register(DropDownTableCell.self, forCellReuseIdentifier: DropDownTableCell.identifier)
    }
    
    func setupUI() {
        addSubview(header)
        header.easy.layout([
            Top().to(safeAreaLayoutGuide, .top), Leading(), Trailing()
        ])
        
        addSubview(scrollView)
        scrollView.easy.layout([Edges(), Top().to(header, .bottom)])
        
        scrollView.addSubview(collectionTopStack)
        collectionTopStack.easy.layout([Top(),Leading(20),Trailing(20),Width(DeviceDimensions.shared.width() - 40)]
        )
        
//        setupStackViews()
        
        addSubview(noConnection)
        noConnection.easy.layout(Edges())
        
        addSubview(noContent)
        noContent.easy.layout(Edges())
        
        addSubview(loadingTransparent)
        loadingTransparent.easy.layout(Edges())
        loadingTransparent.isHidden = true
        
        addSubview(loading)
        loading.easy.layout([
            CenterX(), CenterY(-40), Size(80)
        ])
        loading.isHidden = true
    }
    
    func setupStackViews(rates: [Rate]){
        
        
        collectionTopStack.addArrangedSubview(addInfoLabel)
        collectionTopStack.addArrangedSubview(locationDefiner)
        collectionTopStack.addArrangedSubview(techInspection)
        collectionTopStack.addArrangedSubview(sizeChoice)
      
        
        collectionTopStack.addArrangedSubview(packagesWrapper)
        setupPackages(rates: rates)
        
        collectionTopStack.addArrangedSubview(exactSize)
        exactSize.isHidden = true
        
        collectionTopStack.addArrangedSubview(descriptionMultilineTextField)
        
        collectionTopStack.addArrangedSubview(photosLabel)
        scrollView.addSubview(photosHorizontalCollection)
        photosHorizontalCollection.easy.layout([
            Height(125), Top(20).to(collectionTopStack, .bottom), Leading(), Trailing()
        ])
        
        scrollView.addSubview(collectionBottomStack)
        collectionBottomStack.easy.layout([Top(10).to(photosHorizontalCollection, .bottom),Leading(20),Trailing(20),Width(DeviceDimensions.shared.width() - 40), Bottom()])
        
       
        collectionBottomStack.addArrangedSubview(loaderChoice)
        collectionBottomStack.addArrangedSubview(quantity)
        collectionBottomStack.addArrangedSubview(packageChoice)
        collectionBottomStack.addArrangedSubview(floorChoice)
        collectionBottomStack.addArrangedSubview(waitForSenderChoice)
        collectionBottomStack.addArrangedSubview(waitForReceiverChoice)
        collectionBottomStack.addArrangedSubview(oformleniyeChooseLabel)
        collectionBottomStack.addArrangedSubview(byWhoDropDown)
        collectionBottomStack.addArrangedSubview(whoPayDropDown)
        collectionBottomStack.addArrangedSubview(senderInfoLabel)
        collectionBottomStack.addArrangedSubview(senderName)
        collectionBottomStack.addArrangedSubview(senderPhoneTextField)
        collectionBottomStack.addArrangedSubview(receiverInfoLabel)
        collectionBottomStack.addArrangedSubview(receiverName)
        collectionBottomStack.addArrangedSubview(receiverPhoneTextField)
        collectionBottomStack.addArrangedSubview(totalSumLabel)
        collectionBottomStack.addArrangedSubview(priceField)
        collectionBottomStack.addArrangedSubview(acceptButton)
        
        acceptButton.blackColor()
        acceptButton.layer.cornerRadius = 6
        
        quantity.textField.keyboardType = .numberPad
        
        senderPhoneTextField.textField.leftView = senderPhoneText
        senderPhoneTextField.textField.leftViewMode = .always
        senderPhoneTextField.textField.keyboardType = .numberPad
        
        receiverPhoneTextField.textField.leftView = receiverPhoneText
        receiverPhoneTextField.textField.leftViewMode = .always
        receiverPhoneTextField.textField.keyboardType = .numberPad
        
        currencyLabel.backgroundColor = .whiteBlackColor
        priceField.textField.rightView = currencyLabel
        priceField.textField.rightViewMode = .unlessEditing
        priceField.textField.keyboardType = .numberPad
        
        collectionBottomStack.addArrangedSubview(bottomSpace)
        bottomSpace.easy.layout(Height(50))
        
        addFromWhomDropDown()
        byWhoTransparentView.alpha = 0
        
        addWhoPayDropDown()
        whoPayTransparentView.alpha = 0
    }
    
    func setupPackages(rates: [Rate]){
        packagesCellArray.enumerated().forEach { ind, error in
            packagesCellArray[ind].removeFromSuperview()
        }
        packagesCellArray.removeAll()
        rates.enumerated().forEach { ind, error in
            let package = PackagesCell()
            package.setupData(data: rates[ind])
            package.selectedClickCallback = { [weak self] in
                self?.makeRatesUnselect()
                package.select()
                self?.selectedRateIndex = ind
                self?.delegate?.clearValues()
            }
            package.moreInfoClickCallback = { [weak self] in
                print(ind)
                self?.showRateDescriptionDelegate?.showRateDescription(rateInd: ind)
            }
            packagesStackView.addArrangedSubview(package)
            packagesCellArray.append(package)
        }
        
        packagesWrapper.addSubview(packagesStackView)
        packagesStackView.easy.layout([Edges()])
    }
    
//    -> Bool
    func checkIfFieldsEmpty() -> Bool{
        let whereFrom = locationDefiner.whereFromDefinerView.checkIfEmpty()
        let whereTo = locationDefiner.whereToDefinerView.checkIfEmpty()
        let senderName = senderName.checkIfEmpty()
        let senderPhoneTextField = senderPhoneTextField.checkIfEmpty()
        let receiverName = receiverName.checkIfEmpty()
        let receiverPhoneTextField = receiverPhoneTextField.checkIfEmpty()
        
        if loaderChoice.choiceView.choice == 1 {
            let quantity = quantity.checkIfEmpty()
            if quantity {
                return true
            }
        }
        
        if sizeChoice.choiceView.choice == 0 {
            if whereFrom || whereTo || senderName || senderPhoneTextField || receiverName || receiverPhoneTextField {
                return true
            }
        }else{
            
            let weightField = exactSize.weightField.checkIfEmpty()
            let lengthTextField = exactSize.lengthTextField.checkIfEmpty()
            let widthTextField = exactSize.widthTextField.checkIfEmpty()
            let heightTextField = exactSize.heightTextField.checkIfEmpty()
            
            if whereFrom || whereTo || senderName || senderPhoneTextField || receiverName || receiverPhoneTextField || weightField || lengthTextField || widthTextField || heightTextField{
                return true
            }
        }
        return false
        
    }
    
    func makeRatesUnselect(){
        packagesCellArray.forEach { cell in
            cell.unSelect()
        }
    }
    
    func addFromWhomDropDown(){
        addSubview(byWhoTransparentView)
        byWhoTransparentView.easy.layout(Edges())
        byWhoDownTable.isUserInteractionEnabled = true
        byWhoDownTable.allowsSelection = true
//        fromWhomDownTable.bottomLeftRadius = 8
//        fromWhomDownTable.bottomRightRadius = 8
        byWhoDownTable.layer.borderWidth = 1
        byWhoDownTable.layer.borderColor = UIColor.textColor?.cgColor
        addSubview(byWhoDownTable)
        byWhoDownTable.easy.layout([
            Top().to(byWhoDropDown, .bottom),
            Leading().to(byWhoDropDown, .leading),
            Trailing().to(byWhoDropDown, .trailing),
            Height(0)
        ])
    }
    
    func showCityDropDown(numberOfItems: Double){
        let height = numberOfItems*50
        self.byWhoDownTable.easy.layout(Height(height))
        self.layoutIfNeeded()
    }
    
    func hideCityDropDown(){
        self.byWhoDownTable.easy.layout(Height(0))
        self.collectionBottomStack.layoutIfNeeded()
    }
    
    
    func addWhoPayDropDown(){
        addSubview(whoPayTransparentView)
        whoPayTransparentView.easy.layout(Edges())
        whoPayDropDownTable.isUserInteractionEnabled = true
        whoPayDropDownTable.allowsSelection = true
//        whoPayDropDownTable.bottomLeftRadius = 8
//        whoPayDropDownTable.bottomRightRadius = 8
        whoPayDropDownTable.layer.borderWidth = 1
        whoPayDropDownTable.layer.borderColor = UIColor.textColor?.cgColor
        addSubview(whoPayDropDownTable)
        whoPayDropDownTable.easy.layout([
            Top().to(whoPayDropDown, .bottom),
            Leading().to(whoPayDropDown, .leading),
            Trailing().to(whoPayDropDown, .trailing),
            Height(0)
        ])
    }
    
    func showDistrictDropDown(numberOfItems: Double){
        let height = numberOfItems*50
        self.whoPayDropDownTable.easy.layout(Height(height))
        self.layoutIfNeeded()
    }
    
    func hideDistrictDropDown(){
        self.whoPayDropDownTable.easy.layout(Height(0))
        self.collectionBottomStack.layoutIfNeeded()
    }
    
    func showLoadingOnly(){
        loading.isHidden = false
        loading.startAnimating()
        loadingTransparent.isHidden = false
    }
    
    func dismissLoading(){
        loading.isHidden = true
        loading.stopAnimating()
        loadingTransparent.isHidden = true
    }
    
    func showLoading(){
        loading.isHidden = false
        loading.startAnimating()
        noConnection.isHidden = true
        scrollView.isHidden = true
        noContent.isHidden = true
        loadingTransparent.isHidden = true
    }
    
    func showNoConnection(){
        loading.isHidden = true
        loading.stopAnimating()
        noConnection.isHidden = false
        scrollView.isHidden = true
        noContent.isHidden = true
        loadingTransparent.isHidden = true
    }
    
    func showNoContent(){
        loading.isHidden = true
        loading.stopAnimating()
        noConnection.isHidden = true
        scrollView.isHidden = true
        noContent.isHidden = false
        loadingTransparent.isHidden = true
    }
    
    func showData(){
        loading.isHidden = true
        loading.stopAnimating()
        noConnection.isHidden = true
        scrollView.isHidden = false
        noContent.isHidden = true
        loadingTransparent.isHidden = true
    }
    
    @objc func fromWhomDropDownTap() {
        fromWhomDropDownCallback?()
    }
    
    @objc func whoPayDropDownTap() {
        whoPayDropDownCallback?()
    }
    
    @objc func acceptBtnTap() {
        acceptClickCallback?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
