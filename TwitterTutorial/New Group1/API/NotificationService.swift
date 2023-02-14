//
//  NotificationService.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 14.02.2023.
//

import Firebase

class NotificationService {
    
    static let shared = NotificationService()
    
    private init() {}
    
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil, user: User? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
       
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetId
            REF_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else if let user = user {
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
        }
    }
}
