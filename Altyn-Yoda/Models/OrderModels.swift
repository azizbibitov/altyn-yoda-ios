//
//  OrderModels.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 11.04.2023.
//

import Foundation

struct RatesResponse: Decodable {
    var status: Bool?
    var message: String?
    var code: String?
    var data: [Rate]?
}

struct Rate: Codable {
    var uuid: String?
    var name_tm: String?
    var name_ru: String?
    var name_en: String?
    var image_path: String?
    var with: Int?
    var height: Int?
    var length: Int?
    var weight: Int?
    var service_id: String?
    
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
}

struct UpsertOrderResponse: Decodable {
    var status: Bool?
    var message: String?
    var code: String?
    var data: UUID?
}

struct UUID: Codable {
    var uuid: String?
}

struct Order: Codable {
    var uuid: String?
    var service_id: String?
    var address_from: String?
    var address_to: String?
    var date: String?
    var hour: String?
    var size: Int?
    var weight: Int?
    var width: Int?
    var height: Int?
    var length: Int?
    var loader: Int?
    var quantity: Int?
    var package: Int?
    var floor: Int?
    var wait_sender: Int?
    var wait_recipient: Int?
    var sender: String?
    var sender_phone_number: String?
    var recipient: String?
    var recipient_phone_number: String?
    var price: Int?
    var status: Int?
    var map_from: String?
    var map_to: String?
    var email: String?
    var who_pay: Int?
    var by_who: Int?
    var client_id: String?
    var rate_id: String?
    var description: String?
    // Get
    var image_path: String?
    var service_name: String?
    var created_at: String?
}

struct UploadImageResponse: Decodable {
    var status: Bool?
    var message: String?
    var code: String?
    var data: String?
}

struct AddOrderImagesResponse: Decodable {
    var status: Bool?
    var message: String?
    var code: String?
    var data: UUID?
}


struct GetAllOrdersResponse: Decodable {
    var status: Bool?
    var message: String?
    var code: String?
    var data: [Order]?
}

struct GetAllOrdersBody: Codable {
    var uuid: String
    var status: Int
    var createdAt: String
}

struct PaymentSide {
    var title: String
    var status: Int
}

struct OrderImageResponse: Decodable {
    var status: Bool?
    var message: String?
    var code: String?
    var data: [OrderImage]?
}

struct OrderImage: Codable {
    var uuid: String?
    var order_id: String?
    var image_path: String?
}

struct CancelOrderPostBody: Codable {
    var uuid: String
    var status: Int
}
