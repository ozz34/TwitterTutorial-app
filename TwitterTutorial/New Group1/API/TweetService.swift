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
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration,
                     completion: @escaping DatabaseCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values: [String: Any] = ["uid": uid,
                                     "timestamp": Int(NSDate().timeIntervalSince1970),
                                     "likes": 0,
                                     "retweets": 0,
                                     "caption": caption]
        
        switch type {
        case .tweet:
            REF_TWEETS.childByAutoId().updateChildValues(values) { error, ref in
                //update user-tweet structure after tweet upload completes
                guard let tweetID = ref.key else { return }
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID:1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            REF_TWEET_REPLIES.child(tweet.tweetId).childByAutoId()
                .ref.updateChildValues(values, withCompletionBlock: completion)
        }
    }
    
    func fetchTweets(completion: @escaping([Tweet])-> Void) {
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot  in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetId = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(tweetId: tweetId, user: user, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) -> Void {
        var tweets = [Tweet]()
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(tweetId: tweetID, user: user, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet])-> Void) {
        var tweets = [Tweet]()
        
        REF_TWEET_REPLIES.child(tweet.tweetId).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(tweetId: tweetID, user: user, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping DatabaseCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        REF_TWEETS.child(tweet.tweetId).child("likes").setValue(likes)
        
        if tweet.didLike {
            //remove like data(unlike)
            REF_USER_LIKES.child(uid).child(tweet.tweetId).removeValue { err, ref in
                REF_TWEET_LIKES.child(tweet.tweetId).child(uid).removeValue(completionBlock: completion)
            }
        } else {
            //like tweet
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetId:1]) { err, ref in
                REF_TWEET_LIKES.child(tweet.tweetId).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIsUserLikedTweet(tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(tweet.tweetId).observeSingleEvent(of: .value) {snapshot in
            completion(snapshot.exists())
        }
    }
}

