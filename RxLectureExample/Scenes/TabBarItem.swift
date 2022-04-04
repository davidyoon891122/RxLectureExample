//
//  TabBarItem.swift
//  RxLectureExample
//
//  Created by iMac on 2022/04/04.
//

import Foundation
import UIKit

enum TabBarItem: CaseIterable {
    case asset
    case stock
    
    var title: String {
        switch self {
            
        case .asset:
            return "MyAsset"
        case .stock:
            return "Stocks"
        }
    }
    
    var icon: (defualt: UIImage?, selected: UIImage?) {
        switch self {
        case .asset:
            return (
                UIImage(systemName: "dollarsign.circle"),
                UIImage(systemName: "dollarsign.circle.fill")
            )
        case .stock:
            return (
                UIImage(systemName: "chart.bar"),
                UIImage(systemName: "chart.bar.fill")
            )
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .asset:
            return UIViewController()
        case .stock:
            return UIViewController()
        }
    }
}
