//
//  UserService.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 23.01.2023.
//

import Firebase

typealias DatabaseCompletion = (Error?, DatabaseReference)-> Void

class UserService {
    static let shared = UserService()
    
    private init() {}
    
    func fetchUser(uid: String, completion: @escaping(User)-> Void) {

        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(dictionary: dictionary, uid: uid)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        
        REF_USERS.observe(.childAdded) { snapshot in

            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let user = User(dictionary: dictionary, uid: uid)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping DatabaseCompletion) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping DatabaseCompletion) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
}
