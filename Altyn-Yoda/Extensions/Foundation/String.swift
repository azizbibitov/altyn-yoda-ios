//
//  Foundation.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 15.04.2023.
//

import Foundation

extension String {
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone?
        dateFormatter.locale = Locale(identifier: "en_us_posix")
        let date = dateFormatter.date(from: self)
        return date
    }
    
}
