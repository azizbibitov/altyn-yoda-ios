//
//  Protocols.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 12.04.2023.
//

import Foundation
import CoreLocation

protocol AddLocationProtocol: AnyObject {
    func giveLocation(coordinate: CLLocationCoordinate2D, where_from: Bool)
}

protocol ChooseRateProtocol: AnyObject {
    func clearValues()
}

protocol ShowRateDesctriptionProtocol: AnyObject {
    func showRateDescription(rateInd: Int)
}

protocol PackageChoiceProtocol: AnyObject {
    func calculatePrice()
}

protocol ActionPopupProtocol: AnyObject {
    func action(isTrue: Bool, indexPath: IndexPath)
}
