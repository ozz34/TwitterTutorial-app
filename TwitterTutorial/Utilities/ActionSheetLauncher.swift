//
//  ActionSheetLauncher.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 08.02.2023.
//

import UIKit

class ActionSheetLauncher: NSObject {
    //MARK: -Properties
    private let user: User
    private let tableView = UITableView()
    
    private let identifier = "ActionSheetCell"
    private var window: UIWindow?
    
    //MARK: -Lyfecycle
    init(user: User) {
        self.user = user
        super.init()
        
        configureTableView()
    }
    //MARK: -Helpers
    func show() {
        
        guard let window = UIApplication.shared.connectedScenes.compactMap({($0 as? UIWindowScene)?.keyWindow }).first else { return }
        self.window = window
        
        window.makeKeyAndVisible()

        window.addSubview(tableView)
        tableView.frame = CGRect(x: 0,
                                 y: (window.frame.height) - 300,
                                 width: window.frame.width,
                                 height: 300)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
}
// MARK: -UITableViewDataSource
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        return cell
    }
}

// MARK: -UITableViewDelegate
extension ActionSheetLauncher: UITableViewDelegate {
    
}
