//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 12.01.2023.
//

import UIKit
import Firebase

enum ActionButtonConfiguration {
    case tweet
    case message
}

final class MainTabController: UITabBarController {
    // MARK: - Properties
    var user: User? {
        didSet {
            guard let nav = viewControllers?.first as? UINavigationController else { return }
            guard let feed = nav.topViewController as? FeedController else { return }
            feed.user = user
        }
    }
    
    private var buttonConfig: ActionButtonConfiguration = .tweet
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self,
                         action: #selector(actionButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
        autenticateUserAndConfigureUI()
    }
    
    // MARK: - API
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { [weak self] user in
            self?.user = user
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
    
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        let controller: UIViewController
        switch buttonConfig {
        case .tweet:
            guard let user = user else { return }
            controller = UploadTweetController(user: user, config: .tweet)
        case .message:
            controller = SearchController(config: .messages)
        }
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

    // MARK: - Helpers
    private func configureUI() {
        self.delegate = self
        
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingBottom: 64,
                            paddingRight: 16,
                            width: 56,
                            height: 56)
        actionButton.layer.cornerRadius = 56/2
    }
    
    private func configureViewControllers() {
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected") ?? UIImage(),
                                                rootViewController: feed)
 
        let explore = SearchController(config: .userSearch)
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
    
    private func templateNavigationController(image: UIImage,
                                              rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        //Custom bottom line functionality for another design
        //nav.addCustomBottomLine()
        return nav
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        let imageName = index == 3 ?  "mail" : "new_tweet"
        actionButton.setImage(UIImage(named: imageName), for: .normal)
        buttonConfig = index == 3 ? .message: .tweet
    }
}
// MARK: - UINavigationController
extension UINavigationController {
    func addCustomBottomLine() {
        let lineView = UIView()
        lineView.backgroundColor = .systemGroupedBackground
        
        navigationBar.addSubview(lineView)
        lineView.anchor( left: navigationBar.leftAnchor,
                         bottom: navigationBar.bottomAnchor,
                         right: navigationBar.rightAnchor,
                         paddingLeft: 8,
                         paddingRight: 8,
                         height: 1)
    }
}
