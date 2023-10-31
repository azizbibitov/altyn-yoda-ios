//
//  AuthRequests.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 10.04.2023.
//

import Foundation
import Alamofire
import RxSwift

class AuthRequests {
    
    static let shared = AuthRequests()
    
    func sendSms(phone: String) -> Single<SendSmsResponse> {
        
        return Single<SendSmsResponse>.create { single in
            
            let params: [String : String] = [
                "phoneNumber": "+993\(phone)"
            ]
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: SendSmsResponse.self) { response in
                debugPrint(response)
                let tokenResponse = response.value
                if response.error != nil || tokenResponse?.status == nil {
                    PopUpLancher.showErrorMessage(text: "smth_went_wrong".localized())
                    single(.failure(RequestError.error))
                    return
                }
                
                if !(tokenResponse?.status ?? false) {
                    ErrorCodes.shared.showErrorMessage(errorCode: tokenResponse?.code)
                    single(.failure(RequestError.error))
                    return
                }
                
                DispatchQueue.global(qos: .background).async {
                    guard let tokenRes = tokenResponse else {
                        single(.failure(RequestError.error))
                        return
                    }
                    
                    DispatchQueue.main.async {
                        single(.success(tokenRes))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func checkClient(phone: String, code: Int) -> Single<CheckClientResponse> {
        
        return Single<CheckClientResponse>.create { single in
            
            let params = CheckClientPostModel(phoneNumber: phone, code: code)
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: CheckClientResponse.self) { response in
                debugPrint(response)
                let tokenResponse = response.value
                if response.error != nil || tokenResponse?.status == nil {
                    PopUpLancher.showErrorMessage(text: "smth_went_wrong".localized())
                    single(.failure(RequestError.error))
                    return
                }
                
                if !(tokenResponse?.status ?? false) {
                    ErrorCodes.shared.showErrorMessage(errorCode: tokenResponse?.code)
                    single(.failure(RequestError.error))
                    return
                }
                
                DispatchQueue.global(qos: .background).async {
                    guard let tokenRes = tokenResponse else {
                        single(.failure(RequestError.error))
                        return
                    }
                    
                    DispatchQueue.main.async {
                        single(.success(tokenRes))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func upsertClient(name: String, phoneNumber: String, address: String, location: String?) -> Single<UpsertClientResponse> {
        
        return Single<UpsertClientResponse>.create { single in
            
            let params: [String : String?] = [
                "uuid": "",
                "name": name,
                "phoneNumber": phoneNumber,
                "address": address,
                "location": location
            ]
            
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: UpsertClientResponse.self) { response in
                debugPrint(response)
                let tokenResponse = response.value
                if response.error != nil || tokenResponse?.status == nil {
                    PopUpLancher.showErrorMessage(text: "smth_went_wrong".localized())
                    single(.failure(RequestError.error))
                    return
                }
                
                if !(tokenResponse?.status ?? false) {
                    ErrorCodes.shared.showErrorMessage(errorCode: tokenResponse?.code)
                    single(.failure(RequestError.error))
                    return
                }
                
                DispatchQueue.global(qos: .background).async {
                    guard let tokenRes = tokenResponse else {
                        single(.failure(RequestError.error))
                        return
                    }
                    
                    DispatchQueue.main.async {
                        single(.success(tokenRes))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func deleteUserAccount() -> Single<SendSmsResponse> {
        
        return Single<SendSmsResponse>.create { single in
            
            let params: [String : String] = [
                "uuid": AccountUserDefaults.shared.getUser().uuid
            ]
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: SendSmsResponse.self) { response in
                debugPrint(response)
                let tokenResponse = response.value
                if response.error != nil || tokenResponse?.status == nil {
                    PopUpLancher.showErrorMessage(text: "smth_went_wrong".localized())
                    single(.failure(RequestError.error))
                    return
                }
                
                if !(tokenResponse?.status ?? false) {
                    ErrorCodes.shared.showErrorMessage(errorCode: tokenResponse?.code)
                    single(.failure(RequestError.error))
                    return
                }
                
                DispatchQueue.global(qos: .background).async {
                    guard let tokenRes = tokenResponse else {
                        single(.failure(RequestError.error))
                        return
                    }
                    
                    DispatchQueue.main.async {
                        single(.success(tokenRes))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getProfile() -> Single<CheckClientResponse> {
        
        return Single<CheckClientResponse>.create { single in
            
            let params: [String : String] = [
                "uuid": AccountUserDefaults.shared.getUser().uuid
            ]
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: CheckClientResponse.self) { response in
                debugPrint(response)
                let tokenResponse = response.value
                if response.error != nil || tokenResponse?.status == nil {
                    PopUpLancher.showErrorMessage(text: "smth_went_wrong".localized())
                    single(.failure(RequestError.error))
                    return
                }
                
                if !(tokenResponse?.status ?? false) {
                    ErrorCodes.shared.showErrorMessage(errorCode: tokenResponse?.code)
                    single(.failure(RequestError.error))
                    return
                }
                
                DispatchQueue.global(qos: .background).async {
                    guard let tokenRes = tokenResponse else {
                        single(.failure(RequestError.error))
                        return
                    }
                    
                    DispatchQueue.main.async {
                        single(.success(tokenRes))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func addFcmToken(token: String) -> Single<SendSmsResponse> {
        
        return Single<SendSmsResponse>.create { single in
            
            let params: AddFcmPostModel = AddFcmPostModel(token: token, status: 0)
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: SendSmsResponse.self) { response in
                debugPrint(response)
                let tokenResponse = response.value
                if response.error != nil || tokenResponse?.status == nil {
//                    PopUpLancher.showErrorMessage(text: "smth_went_wrong".localized())
                    single(.failure(RequestError.error))
                    return
                }
                
                if !(tokenResponse?.status ?? false) {
//                    ErrorCodes.shared.showErrorMessage(errorCode: tokenResponse?.code)
                    single(.failure(RequestError.error))
                    return
                }
                
                DispatchQueue.global(qos: .background).async {
                    guard let tokenRes = tokenResponse else {
                        single(.failure(RequestError.error))
                        return
                    }
                    
                    DispatchQueue.main.async {
                        single(.success(tokenRes))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getDeleteToken(completion: @escaping (SendSmsResponse?) ->()) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": AccountUserDefaults.shared.getUser().token
        ]
        
        let urlString = ApiUrl.shared.SAMPLE_URL
        let request = AF.request(urlString, headers: headers)
        request.responseDecodable(of: SendSmsResponse.self) { response in
            debugPrint(response)
            let data = response.value
            
            if response.error != nil{
                completion(nil)
            }
            completion(data)
            
        }
    }
    
    func deleteFcmToken() -> Single<SendSmsResponse> {
        
        return Single<SendSmsResponse>.create { single in
            
            let params: [String: String] = [:]
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: SendSmsResponse.self) { response in
                debugPrint(response)
                let tokenResponse = response.value
                if response.error != nil || tokenResponse?.status == nil {
                    single(.failure(RequestError.error))
                    return
                }
                
                if !(tokenResponse?.status ?? false) {
                    single(.failure(RequestError.error))
                    return
                }
                
                DispatchQueue.global(qos: .background).async {
                    guard let tokenRes = tokenResponse else {
                        single(.failure(RequestError.error))
                        return
                    }
                    
                    DispatchQueue.main.async {
                        single(.success(tokenRes))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
}
