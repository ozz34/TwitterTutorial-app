//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 12.01.2023.
//

import UIKit

class MainTabController: UITabBarController {
    
    //MARK: -Properties
    
    //MARK: -Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureViewControllers()
    }
    //MARK: -Helpers
    func configureViewControllers() {
        
        let feed = FeedController()
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected") ?? UIImage(), rootViewController: feed)
 
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected") ?? UIImage(), rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected") ?? UIImage(), rootViewController: notifications)
   
        let conversation = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(named: "search_unselected") ?? UIImage(), rootViewController: conversation)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white

        return nav
    }
}
