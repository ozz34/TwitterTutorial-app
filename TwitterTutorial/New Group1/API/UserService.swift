//
//  UserService.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 23.01.2023.
//

import Firebase

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
    
    func fetchUsers(completion: @escaping([User])-> Void) {
        var users = [User]()
        
        REF_USERS.observe(.childAdded) { snapshot in

            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let user = User(dictionary: dictionary, uid: uid)
            users.append(user)
            completion(users)
        }
    }
}
