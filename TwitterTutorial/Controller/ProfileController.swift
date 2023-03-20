//
//  ProfileController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 30.01.2023.
//

import Firebase
import UIKit

final class ProfileController: UICollectionViewController {
    // MARK: - Properties
    private let identifier = "TweetCell"
    private let headerIdentifier = "ProfileHeader"
    
    private var user: User
    
    private var selectedFilter: ProfileFilterOptions = .tweets {
        didSet { collectionView.reloadData() }
    }
    
    private var tweets = [Tweet]()
    private var likedTweets = [Tweet]()
    private var replies = [Tweet]()
    
    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets:
            return tweets
        case .replies:
            return replies
        case .likes:
            return likedTweets
        }
    }
        
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        fetchLikedTweets()
        fetchReplies()
        checkIfUserIsFollowed()
        fetchUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - API
    private func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { [weak self] tweets in
            self?.tweets = tweets
            self?.collectionView.reloadData()
        }
    }
    
    private func fetchLikedTweets() {
        TweetService.shared.fetchLikes(forUser: user) { [weak self] likedTweets in
            self?.likedTweets = likedTweets
        }
    }
    
    private func fetchReplies() {
        TweetService.shared.fetchReplies(forUser: user) { [weak self] replies in
            self?.replies = replies
        }
    }
    
    private func checkIfUserIsFollowed() {
        UserService.shared.checkUserIsFollowed(uid: user.uid) { [weak self] isFollowed in
            self?.user.isFollowed = isFollowed
            self?.collectionView.reloadData()
        }
    }
    
    private func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { [weak self] stats in
            self?.user.stats = stats
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - Helpers
    private func configureCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TweetCell else { return UICollectionViewCell() }
        let tweet = currentDataSource[indexPath.row]
        cell.tweet = tweet
        cell.mentionDelegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath)
            as? ProfileHeader else { return UICollectionReusableView() }
        header.user = user
        header.delegate = self
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: currentDataSource[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var height: CGFloat = 300
        if user.bio != nil {
            height += 40
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
        var height = viewModel.size(forWidth: view.frame.width).height + 72
        
        if currentDataSource[indexPath.row].isReply {
            height += 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
}

// MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOptions) {
        selectedFilter = filter
    }
    
    func handleEditProfileFollow() {
        if user.isCurrentUser {
            let controller = EditProfileController(user: user)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { _, _ in
                self.user.isFollowed = false
                self.user.stats?.followers -= 1
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(toUser: self.user, type: .unfollow)
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { _, _ in
                self.user.isFollowed = true
                self.user.stats?.followers += 1
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(toUser: self.user, type: .follow)
            }
        }
    }
    
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - EditProfileControllerDelegate
extension ProfileController: EditProfileControllerDelegate {
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            let nav = UINavigationController(rootViewController: LoginController())
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        self.user = user
        collectionView.reloadData()
    }
}

// MARK: - TweetCellMentionDelegate
extension ProfileController: TweetCellMentionDelegate {
    func handleFetchUserFromTweetController(withUserName userName: String) {
        UserService.shared.fetchUser(withUsername: userName) { [weak self] user in
            let controller = ProfileController(user: user)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
