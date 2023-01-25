//
//  TweetService.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 25.01.2023.
//

import Firebase

class TweetService {
    
    static let shared = TweetService()
    private init() {}
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference)-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values: [String: Any] = ["uid": uid,
                                     "timestamp": Int(NSDate().timeIntervalSince1970),
                                     "likes": 0,
                                     "retweets": 0,
                                     "caption": caption]
        
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
}
