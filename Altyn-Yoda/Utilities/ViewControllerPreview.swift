//
//  ContentView.swift
//  LivePreviewDemo
//
//  Created by Aziz's MacBook Air on 03.04.2023.
//


import UIKit
import SwiftUI

@available(iOS 13.0, *)
struct ViewControllerPreview: UIViewControllerRepresentable {
    
    let viewControllerBuilder: () -> UIViewController

    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Not needed
    }
}

//struct PreviewViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewControllerPreview {
//            PreviewViewController()
//        }
//    }
//}
