//
//  EditProfileController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 17.02.2023.
//

import UIKit

class EditProfileController: UITableViewController {
    //MARK: -Properties
    private let user: User
    
    //MARK: -Lyfecycle
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureNavigationBar()
    }

    //MARK: -Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    @objc func handleDone() {
        dismiss(animated: true)
    }
    
    //MARK: -API
    
    //MARK: -Helpers
    
    func configureNavigationBar() {

        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}


