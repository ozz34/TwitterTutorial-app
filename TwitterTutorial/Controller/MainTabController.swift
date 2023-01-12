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
        feed.tabBarItem.image = UIImage(named: "home_unselected")
        let explore = ExploreController()
        explore.tabBarItem.image = UIImage(named: "search_unselected")
        let notifications = NotificationsController()
        notifications.tabBarItem.image = UIImage(named: "like_unselected")
        let conversation = ConversationsController()
        conversation.tabBarItem.image = UIImage(named: "search_unselected")
        
        viewControllers = [feed, explore, notifications, conversation]
    }
}
