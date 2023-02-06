//
//  TweetHeader.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 06.02.2023.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    //MARK: -Properties
    
    //MARK: -Lyfecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
