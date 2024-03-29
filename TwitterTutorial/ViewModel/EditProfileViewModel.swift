//
//  EditProfileViewModel.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 17.02.2023.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
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
    // MARK: - Properties
    let option: EditProfileOptions
    private let user: User
    
    var titleText: String {
        option.description
    }
    
    var optionValue: String? {
        switch option {
        case .fullName:
            return user.fullName
        case .userName:
            return user.userName
        case .bio:
            return user.bio
        }
    }
    
    var shouldHideTextField: Bool {
        option == .bio
    }
    
    var shouldHideTextView: Bool {
        option != .bio
    }
    
    var shouldHidePlaceholderLabel: Bool {
        user.bio != nil
    }
    
    // MARK: - Lifecycle
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
