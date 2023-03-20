//
//  Tweet.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 25.01.2023.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetId: String
    var likes: Int
    var timestamp: Date!
    let retweetCount: Int
    var user: User
    var didLike = false
    var replyingTo: String?

    var isReply: Bool {
        replyingTo != nil
    }

    init(tweetId: String, user: User, dictionary: [String: Any]) {
        self.tweetId = tweetId
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweets"] as? Int ?? 0

        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        if let replyingTo = dictionary["replyingTo"] as? String {
            self.replyingTo = replyingTo
        }
    }
}
