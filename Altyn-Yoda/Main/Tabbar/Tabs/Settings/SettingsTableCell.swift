//
//  SettingsTableCell.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 05.04.2023.
//

import UIKit
import EasyPeasy

class SettingsTableCell: UITableViewCell {
    
    static let identifier = String(describing: SettingsTableCell.self)
    
    var imageWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(hexString: "#C8C8C8").cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .interMedium(size: 16)
        lbl.textColor = .textColor
        lbl.text = "Profile"
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    var icon: UIImageView = {
        var img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.tintColor = .textColor
        return img
    }()
    
    lazy var rightIcon: UIImageView = {
        var img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "right")!.withRenderingMode(.alwaysTemplate)
        img.tintColor = .textColor!
        return img
    }()
    
    let switchByCode = PVSwitch()
    
    lazy var languageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .interMedium(size: 10)
        lbl.textColor = .textColor
        lbl.text = "app_language".localized()
        lbl.textAlignment = .right
        return lbl
    }()
    
    var switchChangedCallback: ( (Bool)-> Void )?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        switchByCode.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
 
    func cellClear(){
        switchByCode.removeFromSuperview()
        languageLabel.removeFromSuperview()
        rightIcon.removeFromSuperview()
    }
    
    func setupImageAndLabel(){
        cellClear()
        contentView.addSubview(imageWrapper)
        imageWrapper.easy.layout([
            Leading(10), Top(7), Bottom(7), Size(40)
        ])
        
        imageWrapper.addSubview(icon)
        icon.easy.layout(Center(), Size(20))
        
        contentView.addSubview(nameLabel)
        nameLabel.easy.layout([
            Leading(20).to(imageWrapper, .trailing), Top(12.5), Bottom(12.5)
        ])
        
        
    }
    
    
    func setupCellWithRightIcon() {
        cellClear()
        contentView.addSubview(rightIcon)
        rightIcon.easy.layout([
            Trailing(10), Top(13), Bottom(13)
        ])
    }
    
    func setupCellWithSwitch(){
        cellClear()
        switchByCode.isOn = false
        
        switchByCode.isBounceEnabled = true
        switchByCode.thumbOnTintColor = .primaryColor!
        switchByCode.trackOnTintColor = .primaryColor!.withAlphaComponent(0.38)
        
        switchByCode.thumbOffTintColor = UIColor.textColor!
        switchByCode.trackOffTintColor = UIColor(hexString: "#909090")
        
        
        //To handle the events
        
        contentView.addSubview(switchByCode)
        switchByCode.easy.layout([
            Trailing(10), CenterY(), Width(36), Height(20)
        ])
    }
    
    func setupCellForLanguage(){
        cellClear()
        contentView.addSubview(rightIcon)
        rightIcon.easy.layout([
            Trailing(10), Top(13), Bottom(13)
        ])
        
        contentView.addSubview(languageLabel)
        languageLabel.easy.layout([
            Trailing(16).to(rightIcon, .leading), CenterY()
        ])
    }
    
    
    func setupCellData(data: SettingsTableCellModel){
        nameLabel.text = data.title
        icon.image = UIImage(named: data.image)?.withRenderingMode(.alwaysTemplate)
        languageLabel.text = "app_language".localized()
    }
    
    @objc func switchChanged(_ sender: UISwitch){
        switchChangedCallback?(sender.isOn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


