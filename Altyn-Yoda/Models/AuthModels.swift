//
//  AuthModels.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 10.04.2023.
//

import Foundation

struct SendSmsResponse: Decodable {
    var status: Bool?
    var message: String?
    var code: String?
    var data: String?
}


struct CheckClientResponse: Decodable {
    var status: Bool?
    var message: String?
    var code: String?
    var data: CheckClientData?
}

struct CheckClientData: Codable {
    var uuid: String?
    var name: String?
    var phoneNumber: String?
    var address: String?
    var location: String?
    var token: String?
}

struct CheckClientPostModel: Codable {
    var phoneNumber: String
    var code: Int
}

struct UpsertClientResponse: Decodable {
    var status: Bool?
    var message: String?
    var code: String?
    var data: UpsertClientData?
}

struct UpsertClientData: Codable {
    var uuid: String?
    var token: String?
}

struct AddFcmPostModel: Codable {
    var token: String
    var status: Int
}
