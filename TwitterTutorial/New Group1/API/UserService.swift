//
//  UserService.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 23.01.2023.
//

import Firebase

typealias DatabaseCompletion = (Error?, DatabaseReference) -> Void

final class UserService {
    // MARK: - Properties, Lifecycle
    static let shared = UserService()
    
    private init() {}
    
    // MARK: - Fetch
    func fetchUser(uid: String, completion: @escaping (User) -> Void) {
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
    
    func fetchUserStats(uid: String, completion: @escaping (UserRelationStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
           
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
    
    func fetchUser(withUsername username: String, completion: @escaping (User) -> Void) {
        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let uid = snapshot.value as? String else { return }
            self.fetchUser(uid: uid, completion: completion)
        }
    }
    
    // MARK: - Follow/unfollow
    func followUser(uid: String, completion: @escaping DatabaseCompletion) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { _, _ in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping DatabaseCompletion) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { _, _ in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkUserIsFollowed(uid: String, completion: @escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    // MARK: - Save/update
    func saveUserData(user: User, completion: @escaping DatabaseCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["fullname": user.fullName,
                      "username": user.userName,
                      "bio": user.bio ?? ""]
        
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func updateProfileImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let fileName = NSUUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(fileName)
        
        ref.putData(imageData) { _, _ in
            ref.downloadURL { url, _ in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                let values = ["profileImageUrl": profileImageUrl]
                REF_USERS.child(uid).updateChildValues(values) { _, _ in
                    completion(url)
                }
            }
        }
    }
}
