//
//  NotificationTableCell.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 22.04.2023.
//

import UIKit
import EasyPeasy
import Kingfisher

class NotificationTableCell: UITableViewCell {
    
    static let identifier = String(describing: NotificationTableCell.self)
    
    var contentLayer = UIView()
    
    let notificationTitleLabel = GoldenWayLabel(font: .interMedium(size: 12), color: .textColor, alignment: .left, numberOfLines: 0, text: "Zakaz bermek")
    
    let notificationContentLabel = GoldenWayLabel(font: .interRegular(size: 12), color: .textColor, alignment: .left, numberOfLines: 0, text: "Get priсe estimate byinputting paсkage and locations.")
    
    let notificationDateLabel = GoldenWayLabel(font: .interItalic(size: 10), color: .textColor, alignment: .left, numberOfLines: 1, text: "14.01.2023")

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .whiteBlackColor
        contentLayer.backgroundColor = .backgroundColor
        
        contentView.addSubview(contentLayer)
        contentLayer.easy.layout([Top(5), Leading(26), Trailing(26), Bottom(5)])
        
        contentLayer.addSubview(notificationTitleLabel)
        notificationTitleLabel.easy.layout([
            Top(10), Leading(10), Trailing(10)
        ])
        
        contentLayer.addSubview(notificationContentLabel)
        notificationContentLabel.easy.layout([
            Top(8).to(notificationTitleLabel, .bottom), Leading(10), Trailing(10)
        ])
        
        
        contentLayer.addSubview(notificationDateLabel)
        notificationDateLabel.easy.layout([
            Top(8).to(notificationContentLabel, .bottom), Leading(10), Bottom(10)
        ])
    }
    
    
    func setupCellData(_ data: NotificationModel){
        notificationTitleLabel.text = data.title
        notificationContentLabel.text = data.description
        notificationDateLabel.text = TimeAgo.shared.getTimeAndDate(data.createdAt?.getDate())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
