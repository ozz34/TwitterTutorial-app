//
//  NotificationController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 12.01.2023.
//

import UIKit

final class NotificationsController: UITableViewController {
    // MARK: - Properties
    private let identifier = "NotificationCell"
    private var notifications = [Notification]() {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - API
    private func fetchNotifications() {
        refreshControl?.beginRefreshing()
        
        NotificationService.shared.fetchNotifications { [weak self] notifications in
            self?.notifications = notifications
            self?.checkIfUserIsFollowed(notifications: notifications)
            self?.refreshControl?.endRefreshing()
        }
    }
    
    private func checkIfUserIsFollowed(notifications: [Notification]) {
        guard !notifications.isEmpty else { return }
        
        notifications.forEach { notification in
            guard case .follow = notification.type else { return }
            let user = notification.user
            
            UserService.shared.checkUserIsFollowed(uid: user.uid) { [weak self] isFollowed in
                if let index = self?.notifications.firstIndex(where: { $0.user.uid == notification.user.uid }) {
                    self?.notifications[index].user.isFollowed = isFollowed
                }
            }
        }
    }
    
    // MARK: - Selectors
    @objc func handleRefresh() {
        fetchNotifications()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: identifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh),
                                 for: .valueChanged)
    }
}

// MARK: - UITableViewDataSource
extension NotificationsController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? NotificationCell else { return UITableViewCell() }
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationsController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetId = notification.tweetId else { return }
        
        TweetService.shared.fetchTweet(withTweetId: tweetId) { [weak self] tweet in
            let controller = TweetController(tweet: tweet)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - NotificationCellDelegate
extension NotificationsController: NotificationCellDelegate {
    func didTapFollow(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { _, _ in
                cell.notification?.user.isFollowed = false
                
                NotificationService.shared.uploadNotification(toUser: user, type: .unfollow)
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { _, _ in
                cell.notification?.user.isFollowed = true
                
                NotificationService.shared.uploadNotification(toUser: user, type: .follow)
            }
        }
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
