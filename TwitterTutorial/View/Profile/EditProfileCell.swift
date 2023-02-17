//
//  EditProfileCell.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 17.02.2023.
//

import UIKit

class EditProfileCell: UITableViewCell {
    //MARK: -Properties
    var options: EditProfileOptions? {
        didSet {
            
        }
    }

    //MARK: -Lyfecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Selectors
    

    //MARK: -Helpers
}
