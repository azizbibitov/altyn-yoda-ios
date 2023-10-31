//
//  UIStackView.swift
//  Altyn-Yoda
//
//  Created by Parahat Caryyew on 12.02.2023.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView],
                     axis: NSLayoutConstraint.Axis = .horizontal,
                     spacing: CGFloat = 0,
                     align: UIStackView.Alignment = .center,
                     distr: UIStackView.Distribution = .fill) {
        self.init(arrangedSubviews : arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = align
        self.distribution = distr
    }
}

