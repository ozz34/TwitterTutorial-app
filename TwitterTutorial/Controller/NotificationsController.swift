//
//  NotificationController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 12.01.2023.
//


import UIKit

class NotificationsController: UIViewController {
    //MARK: -Properties
    
    //MARK: -Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    //MARK: -Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
    }
    
}

