//
//  ColumnCollectionViewHelper.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 05.04.2023.
//

import UIKit

enum ColumnCollectionViewHelper {
    
    static func getNColumnCGSize(n: Int, height: CGFloat, horizontalPadding: CGFloat, minimumItemSpacing: CGFloat) -> CGSize {
        let width                       = DeviceDimensions.shared.screenWidth()
        let availableWidth              = width - (horizontalPadding * 2) - (minimumItemSpacing * CGFloat(n-1))
        let itemWidth                   = availableWidth / Double(n)
        return CGSize(width: itemWidth, height: height)
    }
    
}

