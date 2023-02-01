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
        
        let ref = REF_TWEETS.childByAutoId()
        
        ref.updateChildValues(values) { error, ref in
            //update user-tweet structure after tweet upload completes
            guard let tweetID = ref.key else { return }
            REF_USER_TWEETS.child(uid).updateChildValues([tweetID:1], withCompletionBlock: completion)
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
    }


