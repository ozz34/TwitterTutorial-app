//
//  EditProfileViewModel.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 17.02.2023.
//

import Foundation

enum  EditProfileOptions: Int, CaseIterable {
    case fullName
    case userName
    case bio
    
    var description: String {
        switch self {
        case .fullName:
           return "Name"
        case .userName:
            return "Username"
        case .bio:
            return "Bio"
        }
    }
}

struct EditProfileViewModel {
    
}
