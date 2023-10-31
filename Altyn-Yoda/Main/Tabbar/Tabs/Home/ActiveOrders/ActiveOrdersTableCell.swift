//
//  ActiveOrdersTableCell.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 21.04.2023.
//

import UIKit
import EasyPeasy
import Kingfisher

class ActiveOrdersTableCell: UITableViewCell {
    
    static let identifier = String(describing: ActiveOrdersTableCell.self)
    
//    var contentLayer = UIView()
    
    var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .whiteBlackColor
        img.kf.indicatorType = .activity
        img.layer.cornerRadius = 4
        img.image = UIImage(named: "order_sample_image")
        return img
    }()
    
    let orderFrom = GoldenWayLabel(font: .interMedium(size: 16), color: .textColor, alignment: .left, numberOfLines: 1, text: "Zakaz bermek")
    
    var arrowSwapImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.image = UIImage(named: "arrow-swap")
        return img
    }()
    
    let orderTo = GoldenWayLabel(font: .interMedium(size: 16), color: .textColor, alignment: .left, numberOfLines: 1, text: "Get priсe estimate byinputting paсkage and locations.")
    
    let orderDateLabel = GoldenWayLabel(font: .interItalic(size: 10), color: .textColor, alignment: .left, numberOfLines: 0, text: "14.01.2023")
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .whiteBlackColor
        self.contentView.backgroundColor = .backgroundColor
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 2.5, left: 21, bottom: 2.5, right: 21))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        contentView.addSubview(contentLayer)
//        contentLayer.easy.layout([Edges()])
        
        contentView.addSubview(image)
        image.easy.layout([
            Top(10), Trailing(10), Height(53), Width(57), Bottom(10)
        ])
        
        contentView.addSubview(orderFrom)
        orderFrom.easy.layout(Top().to(image, .top), Leading(10), Trailing(5).to(image, .leading))
        
        contentView.addSubview(orderTo)
        orderTo.easy.layout([
            Leading(10), Top(2).to(orderFrom, .bottom), Trailing(5).to(image, .leading)
        ])
        
        contentView.addSubview(orderDateLabel)
        orderDateLabel.easy.layout([
            Trailing(20).to(image, .leading), Top().to(orderTo, .bottom)
        ])
        
    }
    
    func setupCellData(_ data: Order){
        orderFrom.text = data.address_from
        image.kf.setImage(with: ApiUrl.shared.getPath(serverPath: data.image_path ?? ""))
        orderDateLabel.text = TimeAgo.shared.getTimeAndDate(data.created_at?.getDate())
        orderTo.text = data.address_to
        
        let themeRaw = ThemeUserDefaults.shared.theme.rawValue
        var isDark: Bool = false
        if themeRaw == 0 { isDark = false } else { isDark = true }
        if isDark{
            arrowSwapImage.image = UIImage(named: "arrow-swap-dark")
        }else{
            arrowSwapImage.image = UIImage(named: "arrow-swap")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


