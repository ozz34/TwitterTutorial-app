//
//  NotificationViewModel.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 14.02.2023.
//

import UIKit

struct NotificationViewModel {
    // MARK: - Properties
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var notificationMessage: String {
        switch type {
        case .follow: return " started following you"
        case .like: return " liked your tweet"
        case .reply: return " replied to your tweet"
        case .retweet: return " retweeted your tweet"
        case .mention: return " mentioned you in tweet"
        case .unfollow: return " unfollowed you"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else { return nil }
        let attributedText = NSMutableAttributedString(string: user.userName,
                                                       attributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
        
        attributedText.append(NSAttributedString(string: notificationMessage,
                                                 attributes: [.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: "  \(timestamp)",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 12),
                                                              .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    
    var profileImageUrl: URL? {
        user.profileImageUrl
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonText: String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    private var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "2m"
    }

    // MARK: - Lifecycle
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
