//
//  TabBarViewController.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 16/10/22.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        hidesBottomBarWhenPushed = true
        self.setUpVCs()
    }
    
    func setUpVCs() {
        viewControllers = [
            createNavController(for: ChatViewController(), title: "Chat", image: UIImage(systemName: "message")!),
            createNavController(for: CommentsViewController(), title: "Comments", image: UIImage(systemName: "tray.2")!)
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
