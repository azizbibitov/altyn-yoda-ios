//
//  PackagesCell.swift
//  SalamExpress
//
//  Created by Parahat Caryyew on 06.03.2023.
//

import UIKit
import EasyPeasy
import ContextMenuSwift
import Kingfisher

class PackagesCell: UIView {
    
    var containerImg = UIImageView(name: "", size: 60, cr: 6)
    var title = UILabel(text: "Конверт", font: .interSemiBold(size: 16))
    var sizesLabel = UILabel(text: "45x35x5 см", font: .interRegular(size: 12))
    var moreInfoBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "info")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .primaryColor
        btn.imageView?.easy.layout(Size(25), Center())
        btn.isHidden = true
        return btn
    }()
    var weightLabel = UILabel(text: "до 2 кг", font: .interRegular(size: 12), align: .right)
    var stack: UIStackView!
    var textStack: UIStackView!
    var textStack2: UIStackView!
    var rateDescriptionText: String = ""
    
    var selectedClickCallback: ( ()-> Void )?
    var moreInfoClickCallback: ( ()-> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func setupUI(){
        textStack = UIStackView(arrangedSubviews: [title, sizesLabel],
                                axis: .vertical,
                                spacing: 8,
                                align: .fill)
        textStack2 = UIStackView(arrangedSubviews: [weightLabel, moreInfoBtn],
                                axis: .vertical,
                                spacing: 0,
                                align: .trailing)
        
        stack = UIStackView(arrangedSubviews: [containerImg,
                                               textStack,
                                               textStack2],
                            spacing: 10)
        self.addSubview(stack)
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor(hexString: "#D0D0D0").cgColor
        self.layer.borderWidth = 1
        stack.easy.layout(Edges(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
        containerImg.backgroundColor = .gray95
        containerImg.kf.indicatorType = .activity
        containerImg.layer.cornerRadius = 6
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedClick)))
    }
    
    func setupData(data: Rate){
        title.text = data.getLocalizedName()
        weightLabel.text = "until_prefix".localized() + "\(data.weight ?? 0)" + "until_suffix".localized()
        containerImg.kf.setImage(with: ApiUrl.shared.getPath(serverPath: data.image_path ?? ""))
        sizesLabel.text = "\(data.with ?? 0)x\(data.height ?? 0)x\(data.length ?? 0)" + "sm".localized()
        rateDescriptionText = data.getLocalizedName() ?? ""
        if #available(iOS 15.0, *) {
            moreInfoBtn.menu = UIMenu(children: [
                UIDeferredMenuElement.uncached { [weak self] completion in
                    var actions = [UIMenuElement]()
                    
                    let block = UIAction(
                        title: self!.rateDescriptionText,
                        image: nil){ _ in
                            print("action")
                    }
                    actions.append(block)
                    completion(actions)
                }
            ])
            moreInfoBtn.showsMenuAsPrimaryAction = true
        }else{
            moreInfoBtn.addTarget(self, action: #selector(moreInfoClick), for: .touchUpInside)
        }
    }
    
    func select(){
        backgroundColor = .primaryColor?.withAlphaComponent(0.1)
    }
    
    func unSelect(){
        backgroundColor = .clear
    }
    
    @objc func selectedClick() {
        selectedClickCallback?()
    }
    
    @objc func moreInfoClick() {
        
        let info = ContextMenuItemWithImage(title: self.rateDescriptionText, image: nil, color: .white)
        CM.items = [info]
        CM.showMenu(viewTargeted: self.moreInfoBtn, delegate: self, animated: true)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// Context menu
extension PackagesCell : ContextMenuDelegate {
    
    func contextMenuDidSelect(_ contextMenu: ContextMenuSwift.ContextMenu, cell: ContextMenuSwift.ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuSwift.ContextMenuItem, forRowAt index: Int) -> Bool {
        return true
    }
    
    func contextMenuDidDeselect(_ contextMenu: ContextMenuSwift.ContextMenu, cell: ContextMenuSwift.ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuSwift.ContextMenuItem, forRowAt index: Int) {
        
    }
    
    func contextMenuDidAppear(_ contextMenu: ContextMenuSwift.ContextMenu) {
        
    }
    
    func contextMenuDidDisappear(_ contextMenu: ContextMenuSwift.ContextMenu) {
        
    }
    
//    func contextMenuDidSelect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self ] in
//            switch index {
//            case 0:
//                self?.unblockUser(toBlock: self?.room.isBlocked == 0 ? true : false)
//
//            case 1:
//                self?.toggleNotificationStatus()
//
//            case 2:
//                WSManager.shared.roomEvents(roomUuid: self?.room.UUID ?? "", date: self?.room.lastMessage?.date ?? "", event: 3)
//                LocalDB.shared.room.deleteByUuid(self?.room.UUID ?? "")
//                self?.navigationController?.popViewController(animated: true)
//
//            default:
//                break
//            }
//        }
//        return true
//    }
//
//    func contextMenu(_ contextMenu: ContextMenu, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
//        return true
//    }
}
