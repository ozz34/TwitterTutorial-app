//
//  UploadTweetController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 24.01.2023.
//

import UIKit

class UploadTweetController: UIViewController {
    
    //MARK: -Properties
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    //MARK: -Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    //MARK: -Selectors
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    @objc func handleUploadTweet() {
        print("Tweet")
    }
    
    
    //MARK: -API
    
    
    
    //MARK: -Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        
    }
}
