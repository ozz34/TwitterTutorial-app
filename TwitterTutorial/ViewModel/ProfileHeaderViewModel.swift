//
//  ProfileHeaderViewModel.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 01.02.2023.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
   
    let userNameText: String
    let fullNameText: String
    let bioText: String
    
    var followersText: NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: " followers")
    }
    
    var followingText: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: " following")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        } else if user.isFollowed {
            return "Following"
        } else {
            return "Follow"
        }
    }
    
    init(user: User){
        self.user = user
        self.userNameText = "@" + user.userName
        self.fullNameText = user.fullName
        self.bioText = user.bio ?? ""
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: text,
                                                  attributes: [.font: UIFont.boldSystemFont(ofSize: 14),
                                                               .foregroundColor: UIColor.lightGray]
                                                 ))
        
        return attributedTitle
    }
}
