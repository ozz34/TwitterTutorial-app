//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 12.01.2023.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    //MARK: -Properties
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?.first as? UINavigationController else { return }
            guard let feed = nav.topViewController as? FeedController else { return }
            feed.user = user
        }
    }
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: -Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
        autenticateUserAndConfigureUI()
        //logUserOut()
    }
    
    //MARK: -API
    
    func fetchUser() {
        UserService.shared.fetchUser { user in
            self.user = user
        }
    }
    
    func autenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
            print("DEBUG: Did log user out")
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    //MARK: -Selectors
    @objc func actionButtonTapped() {
        let nav = UINavigationController(rootViewController: UploadTweetController())
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

    //MARK: -Helpers

    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingBottom: 64,
                            paddingRight: 16,
                            width: 56,
                            height: 56)
        actionButton.layer.cornerRadius = 56/2
    }
    
    func configureViewControllers() {
        
        let feed = FeedController()
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected") ?? UIImage(),
                                                rootViewController: feed)
 
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected") ?? UIImage(),
                                                rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected") ?? UIImage(),
                                                rootViewController: notifications)
   
        let conversation = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1") ?? UIImage(),
                                                rootViewController: conversation)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white

        return nav
    }
}
