//
//  ConversationController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 12.01.2023.
//

import UIKit

// TODO: Configure controller
final class ConversationsController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}
