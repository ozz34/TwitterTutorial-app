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
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var footerView: UIView = {
       let view = UIView()
        
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left:view.leftAnchor,
                            right: view.rightAnchor,
                            paddingLeft: 12,
                            paddingRight: 12)
        cancelButton.centerY(inView: view)
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 50 / 2
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
     
        return button
    }()
    
    //MARK: -Lyfecycle
    init(user: User) {
        self.user = user
        super.init()
        
        configureTableView()
    }
    //MARK: -Selectors
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 280
        }
    }
    
    //MARK: -Helpers
    func show() {
        
        guard let window = UIApplication.shared.connectedScenes.compactMap({($0 as? UIWindowScene)?.keyWindow }).first else { return }
        self.window = window
        window.makeKeyAndVisible()
        
        window.addSubview(blackView)
        blackView.frame = window.frame

        window.addSubview(tableView)
        let height = CGFloat(3 * 60) + 100
        tableView.frame = CGRect(x: 0,
                                 y: window.frame.height,
                                 width: window.frame.width,
                                 height: height)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.tableView.frame.origin.y -= height
        }
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: identifier)
    }
}
// MARK: -UITableViewDataSource
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ActionSheetCell
        else { return UITableViewCell()}
        
        
        return cell
    }
}

// MARK: -UITableViewDelegate
extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        60
    }
}
