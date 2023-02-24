//
//  ConversationController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 12.01.2023.
//

import UIKit

//TODO: configure controller
class ConversationsController: UIViewController {
    //MARK: -Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
   
    //MARK: -Helpers
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}

