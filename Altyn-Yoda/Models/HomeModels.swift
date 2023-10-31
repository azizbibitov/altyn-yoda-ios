//
//  HomeModels.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 11.04.2023.
//

import Foundation

struct BannersResponse: Decodable {
    var status: Bool?
    var message: String?
    var code: String?
    var data: [Banner]?
}

struct Banner: Codable {
    var uuid: String?
    var imagePath: String?
    var url: String?
}

struct ServicesResponse: Decodable {
    var status: Bool?
    var message: String?
    var code: String?
    var data: [Service]?
}

struct Service: Codable {
    var uuid: String?
    
    var name_tm: String?
    var name_ru: String?
    var name_en: String?
    
    var description_tm: String?
    var description_ru: String?
    var description_en: String?
    
    var image_path: String?
    var service_price: Int?
    var price_per_pack: Int?
    var total_price: Int?
    var default_employee_count: Int?
    var default_car_count: Int?
    var status: Int?
    
    func getLocalizedName() -> String? {
        let languageCode = AccountUserDefaults.shared.getLanguageCode()
        switch languageCode {
        case "en":
            return name_en
        case "ru":
            return name_ru
        case "tk":
            return name_tm
        default:
            return name_en
        }
    }
    
    func getLocalizedDescription() -> String? {
        let languageCode = AccountUserDefaults.shared.getLanguageCode()
        switch languageCode {
        case "en":
            return description_en
        case "ru":
            return description_ru
        case "tk":
            return description_tm
        default:
            return description_en
        }
    }
}

struct GetAllNotificationsPostBody: Codable {
    var page: Int
    var limit: Int
    var createdAt: String
}

struct AllNotificationsResponse: Decodable {
    var status: Bool?
    var message: String?
    var code: String?
    var data: [NotificationModel]?
}

struct NotificationModel: Codable {
    var uuid: String?
    var title: String?
    var description: String?
    var date: String?
    var createdAt: String?
}
