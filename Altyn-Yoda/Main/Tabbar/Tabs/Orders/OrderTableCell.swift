//
//  OrderTableCell.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 05.04.2023.
//

import UIKit
import EasyPeasy
import Kingfisher

class OrderTableCell: UITableViewCell {
    
    static let identifier = String(describing: OrderTableCell.self)
    
    var contentLayer = UIView()
    
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
    
//    let orderTitleLabel = GoldenWayLabel(font: .interMedium(size: 16), color: .textColor, alignment: .left, numberOfLines: 1, text: "Zakaz bermek")
//
//
//
//    let orderStatusLabel = GoldenWayLabel(font: .interMedium(size: 10), color: .primaryColor, alignment: .left, numberOfLines: 0, text: "Geldi")
//
//
    
    
    
    let orderFrom = GoldenWayLabel(font: .interMedium(size: 12), color: .textColor, alignment: .left, numberOfLines: 1, text: "")
    
    let orderTo = GoldenWayLabel(font: .interMedium(size: 12), color: .textColor, alignment: .left, numberOfLines: 1, text: "")
    
    let orderDateLabel = GoldenWayLabel(font: .interRegular(size: 10), color: .textColor, alignment: .left, numberOfLines: 1, text: "14.01.2023")
    
    let orderWhoPayLabel = GoldenWayLabel(font: .interRegular(size: 12), color: .textColor, alignment: .left, numberOfLines: 1, text: "Geldi")
    
    let orderStatusLabel = GoldenWayLabel(font: .interRegular(size: 12), color: .textColor, alignment: .left, numberOfLines: 1, text: "Geldi")
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .whiteBlackColor
        self.contentView.backgroundColor = .backgroundColor
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 2.5, left: 21, bottom: 2.5, right: 21))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(contentLayer)
        contentLayer.easy.layout([Edges()])
        
        contentView.addSubview(image)
        image.easy.layout([
            Top(10), Bottom(10), Trailing(10), Width(100), Height(105)
        ])
        
        contentView.addSubview(orderFrom)
        orderFrom.easy.layout([
            Top(10), Leading(10), Trailing(10).to(image, .leading)
        ])
        
        contentView.addSubview(orderTo)
        orderTo.easy.layout([
            Top(5).to(orderFrom, .bottom), Leading().to(orderFrom, .leading), Trailing(10).to(image, .leading)
        ])
        
        contentView.addSubview(orderDateLabel)
        orderDateLabel.easy.layout([
            Top(7).to(orderTo, .bottom), Leading().to(orderFrom, .leading), Trailing(10).to(image, .leading)
        ])
        
        contentView.addSubview(orderWhoPayLabel)
        orderWhoPayLabel.easy.layout([
            Top(7).to(orderDateLabel, .bottom), Leading().to(orderFrom, .leading), Trailing(10).to(image, .leading)
        ])
        
        contentView.addSubview(orderStatusLabel)
        orderStatusLabel.easy.layout([
            Top(7).to(orderWhoPayLabel, .bottom), Leading().to(orderFrom, .leading), Trailing(10).to(image, .leading)
        ])
        
    }
    
    func setupCellData(_ data: Order){
        image.kf.setImage(with: ApiUrl.shared.getPath(serverPath: data.image_path ?? ""))
        orderFrom.text = data.address_from
        orderTo.text = data.address_to
        orderDateLabel.text = TimeAgo.shared.getTimeAndDate(data.created_at?.getDate())
        let whoPay = data.who_pay == 0 ? "sender".localized() : "receiver".localized()
        let whoPayText = "who_pay".localized() + ": " + whoPay
        orderWhoPayLabel.setFontText(whoPayText, withFontPart: whoPay, font: .interMedium(size: 12))
        let status = giveStatusString(data.status ?? 0)
        let statusText = "status".localized() + ": " + status
        orderStatusLabel.setText(statusText, withColorPart: status, color: .primaryColor!)
    }
    
    func giveStatusString(_ status: Int) -> String{
        switch status {
        case 0:
            return "waiting".localized()
        case 1:
            return "accepted".localized()
        case 2:
            return "in_progress".localized()
        case 3:
            return "completed".localized()
        case 4:
            return "canceled".localized()
        default:
            return ""
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

