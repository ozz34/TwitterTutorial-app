//
//  ExploreController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 12.01.2023.
//


import UIKit

class ExploreController: UITableViewController {
    
    //MARK: -Properties
    private let identifier = "UserCell"
    
    //MARK: -Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
   
    //MARK: -Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        tableView.register(UserCell.self, forCellReuseIdentifier: identifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
}

extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? UserCell else { return
            UITableViewCell() }
        
        return cell
        }
}
