//
//  ActionSheetLauncher.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 08.02.2023.
//

import Foundation

class ActionSheetLauncher: NSObject {
    //MARK: -Properties
    private let user: User
    
    init(user: User) {
        self.user = user
        super.init()
    }
    //MARK: -Helpers
    func show() {
        print("\(user.userName)")
    }
}
