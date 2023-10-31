//
//  OrderRequests.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 11.04.2023.
//

import Foundation
import Alamofire
import RxSwift

class OrderRequests {
    
    static let shared = OrderRequests()
    
    func getAllRatesByServiceID(serviceID: String) -> Single<RatesResponse> {
        
        return Single<RatesResponse>.create { single in
            
            let params: [String : String] = [
                "uuid": serviceID
            ]
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: RatesResponse.self) { response in
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
    
    func upsertOrder(model: Order) -> Single<UpsertOrderResponse> {
        
        return Single<UpsertOrderResponse>.create { single in
            
            let params: Order = model
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: UpsertOrderResponse.self) { response in
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
    
    func addOrderImages(order_id: String, image_path: String) -> Single<AddOrderImagesResponse> {
        
        return Single<AddOrderImagesResponse>.create { single in
            
            let params: [String : String] = [
                "order_id": order_id,
                "image_path": image_path
            ]
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: AddOrderImagesResponse.self) { response in
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
 
    func getAllOrders(model: GetAllOrdersBody) -> Single<GetAllOrdersResponse> {
        
        return Single<GetAllOrdersResponse>.create { single in
            
            let params: GetAllOrdersBody = model
            
            let af = Request.shared.request(url: ApiUrl.shared.SAMPLE_URL, params: params)
            af.responseDecodable(of: GetAllOrdersResponse.self) { response in
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
    
    func getOrderImages(orderID: String) -> Single<OrderImageResponse> {
        
        return Single<OrderImageResponse>.create { single in
            
            let params: [String:String] = [
                "uuid": orderID
            ]
            
            let af = Request.shared.request(url: "https://altynyoda.com.tm/api/v1/admin/user/get-order-images", params: params)
            af.responseDecodable(of: OrderImageResponse.self) { response in
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
    
    func cancelOrder(orderID: String) -> Single<SendSmsResponse> {
        
        return Single<SendSmsResponse>.create { single in
            
            let params: CancelOrderPostBody = CancelOrderPostBody(uuid: orderID, status: 4)
            
            let af = Request.shared.request(url: "https://altynyoda.com.tm/api/v1/admin/user/cancel-order", params: params)
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
    
}
