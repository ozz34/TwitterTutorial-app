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
    
    func fetchUser() {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
           
            let user = User(dictionary: dictionary, uid: uid)
        }
    }
}
