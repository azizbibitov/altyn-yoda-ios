//
//  ApiUrl.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 10.04.2023.
//

import Foundation

class ApiUrl {
    static let shared = ApiUrl()
    
    let server = "https://sample"
    static let BASE_URL = "https://sample"
    
    
    let SAMPLE_URL = BASE_URL + "sample"
    
    
    func getPath(path: String) -> URL? {
        return URL(string: path)
    }
    
    func getPath(serverPath: String) -> URL? {
        return URL(string: self.server + serverPath)
    }
    
}
