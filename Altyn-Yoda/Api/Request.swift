//
//  Request.swift
//  Salam-beta
//
//  Created by Maksadow Meylis on 17.04.2022.
//

import Foundation
import Alamofire
import RxSwift

class Request {
    
    static let shared = Request()
    
    public func request<Parameters: Encodable>(
        url: String,
        params: Parameters,
        
        method: HTTPMethod = .post,
        headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": AccountUserDefaults.shared.getUser().token
        ],
        encoder: ParameterEncoder = JSONParameterEncoder.default
    ) -> DataRequest {
        
        let af = AF.request(
            url,
            method: method,
            parameters: params,
            encoder: encoder,
            headers: headers
        )
        
        return af
        
    }
    
}
