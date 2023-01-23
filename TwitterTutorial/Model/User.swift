//
//  User.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 23.01.2023.
//

import Foundation

struct User {
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let uid: String
    
    init(dictionary: [String: Any], uid: String) {
        self.email = dictionary["email"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.fullName = dictionary["fullname"] as? String ?? ""
        self.userName = dictionary["username"] as? String ?? ""
        self.uid = uid
    }
}
