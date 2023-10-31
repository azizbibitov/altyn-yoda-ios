//
//  HomeRequests.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 11.04.2023.
//

import Foundation
import Alamofire
import RxSwift

class HomeRequests {
    
    static let shared = HomeRequests()
    
    func getAllBanners() -> Single<BannersResponse> {
        
        return Single<BannersResponse>.create { single in
            
            let params: [String : String] = [:]
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: BannersResponse.self) { response in
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
    
    func getAllServices() -> Single<ServicesResponse> {
        
        return Single<ServicesResponse>.create { single in
            
            let params: [String : String] = [:]
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: ServicesResponse.self) { response in
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
    
    
    func getAllNotifications(createdAt: String) -> Single<AllNotificationsResponse> {
        
        return Single<AllNotificationsResponse>.create { single in
            
            let params: GetAllNotificationsPostBody = GetAllNotificationsPostBody(page: 1, limit: 10, createdAt: createdAt)
            
            let af = Request.shared.request(url: "https://altynyoda.com.tm/api/v1/admin/user/get-all-notifications", params: params)
            af.responseDecodable(of: AllNotificationsResponse.self) { response in
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
}
