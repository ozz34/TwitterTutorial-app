//
//  User.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 23.01.2023.
//

import Foundation
import Firebase

struct User {
    let email: String
    let fullName: String
    let userName: String
    var profileImageUrl: URL?
    let uid: String
    var isFollowed = false
    var stats: UserRelationStats?
    var bio: String?
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid 
    }
    
    init(dictionary: [String: Any], uid: String) {
        self.uid = uid
        
        self.email = dictionary["email"] as? String ?? ""
        self.fullName = dictionary["fullname"] as? String ?? ""
        self.userName = dictionary["username"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
