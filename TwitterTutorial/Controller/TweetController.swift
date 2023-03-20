//
//  TweetController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 06.02.2023.
//

import UIKit

final class TweetController: UICollectionViewController {
    // MARK: - Properties
    private let tweet: Tweet
    private var replies = [Tweet]() {
        didSet { collectionView.reloadData() }
    }
    
    private var actionSheetLauncher: ActionSheetLauncher!
    
    private let identifier = "TweetCell"
    private let headerIdentifier = "TweetHeader"
    
    // MARK: - Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
    }
    
    // MARK: - API
    private func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { [weak self] replies in
            self?.replies = replies
        }
    }
  
    // MARK: - Helpers
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    private func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
}

// MARK: - UICollectionViewDelegate
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath)
            as? TweetHeader else { return UICollectionReusableView() }
        header.tweet = tweet
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDataSource
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TweetCell else { return UICollectionViewCell() }
        cell.tweet = replies[indexPath.row]
        cell.mentionDelegate = self
        return cell
    }
}

// MARK: - TweetCellMentionDelegate
extension TweetController: TweetCellMentionDelegate {
    func handleFetchUserFromTweetController(withUserName userName: String) {
        UserService.shared.fetchUser(withUsername: userName) { [weak self] user in
            let controller = ProfileController(user: user)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
            
        return CGSize(width: view.frame.width, height: captionHeight + 230)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let reply = replies[indexPath.row]
        let viewModel = TweetViewModel(tweet: reply)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
            
        return CGSize(width: view.frame.width, height: captionHeight + 85)
    }
}

// MARK: - TweetHeaderDelegate
extension TweetController: TweetHeaderDelegate {
    func handleFetchUser(withUserName userName: String) {
        UserService.shared.fetchUser(withUsername: userName) { [weak self] user in
            let controller = ProfileController(user: user)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func showActionSheet() {
        if tweet.user.isCurrentUser {
            showActionSheet(forUser: tweet.user)
        } else {
            UserService.shared.checkUserIsFollowed(uid: tweet.user.uid) { isFollowed in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
    }
}

// MARK: - ActionSheetLauncherDelegate
extension TweetController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { _, _ in
                NotificationService.shared.uploadNotification(toUser: user, type: .follow)
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { _, _ in
                NotificationService.shared.uploadNotification(toUser: user, type: .unfollow)
            }
        // TODO: Realize functionality
        case .report:
            print("Report")
        case .delete:
            print("Delete")
        }
    }
}
