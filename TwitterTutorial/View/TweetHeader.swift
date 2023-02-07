//
//  TweetHeader.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 06.02.2023.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    //MARK: -Properties
    
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Peter Parker"
        return label
    }()
    
   private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Spiderman"
        
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "Some Text"
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "6: 33 PM -"
        
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor,
                        paddingLeft: 8,
                        paddingRight: 8,
                        height: 1)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor( left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 8,
                         paddingRight: 8,
                         height: 1)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view,
                      leftAnchor: view.leftAnchor,
                      paddingLeft: 16)
        
        return view
    }()
    
    private let retweetsLabel = UILabel()
    private let likesLabel = UILabel()
    
    private lazy var commentButton: UIButton = {
      let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
      let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var likeButton: UIButton = {
      let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var shareButton: UIButton = {
      let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: -Lyfecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelStack = UIStackView(arrangedSubviews: [fullNameLabel, userNameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stack.axis = .horizontal
        stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(top: topAnchor,
                     left: leftAnchor,
                     paddingTop: 16,
                     paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            paddingTop: 20,
                            paddingLeft: 16,
                            paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor,
                            left: leftAnchor,
                            paddingTop: 20,
                            paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.anchor(top: topAnchor,
                             right: rightAnchor,
                             paddingTop: 16,
                             paddingRight: 16)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         paddingTop: 20,
                         height: 40)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton,
                                                        retweetButton,
                                                        likeButton,
                                                        shareButton])
        actionStack.spacing = 72
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom: bottomAnchor,
                           paddingBottom: 12)
                           
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Selectors
    @objc func handleProfileImageTapped() {

    }
    @objc func showActionSheet() {

    }
    
    
    @objc func handleCommentTapped() {

    }
    
    @objc func handleRetweetTapped() {

    }
    
    @objc func handleLikeTapped() {

    }
    
    @objc func handleShareTapped() {

    }
    
    
    //MARK: -Helpers
    func configure() {
        guard let tweet else { return }
        
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullNameLabel.text = tweet.user.fullName
        userNameLabel.text = viewModel.userNameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headerTimestamp
        retweetsLabel.attributedText = viewModel.retweetsAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
        
    }
    
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        
        return button
    }
}
