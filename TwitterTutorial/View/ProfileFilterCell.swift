//
//  ProfileFilterCell.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 31.01.2023.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    //MARK: -Properties
    
    var option: ProfileFilterOptions? {
        didSet {
            titleLabel.text = option?.description
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test"
    
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    //MARK: -Lyfecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Helpers

}
   

