//
//  TabBarController.swift
//  RxLectureExample
//
//  Created by iMac on 2022/04/04.
//

import UIKit

final class TabBarController: UITabBarController {
    private lazy var tabViewController: [UIViewController] = {
        return TabBarItem.allCases.map {
            let viewController = $0.viewController
            viewController.tabBarItem = UITabBarItem(
                title: $0.title,
                image: $0.icon.defualt,
                selectedImage: $0.icon.selected
            )
            return viewController
        }
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = tabViewController
    }
}
