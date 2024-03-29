//
//  ProfileHeader.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 30.01.2023.
//

import UIKit

// MARK: - ProfileHeaderDelegate
protocol ProfileHeaderDelegate: AnyObject {
    func handleDismissal()
    func handleEditProfileFollow()
    func didSelect(filter: ProfileFilterOptions)
}

final class ProfileHeader: UICollectionReusableView {
    // MARK: - Properties
    var user: User? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let filterBar = ProfileFilterView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor,
                          left: view.leftAnchor,
                          paddingTop: 42,
                          paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp")?.withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(handleDismissal),
                         for: .touchUpInside)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 80 / 2
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.layer.cornerRadius = 32 / 2
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.addTarget(self,
                         action: #selector(handleEditProfileFollow),
                         for: .touchUpInside)
        return button
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        return label
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        let followTap = UIGestureRecognizer(target: self,
                                            action: #selector(handleFollowersTapped))
        label.addGestureRecognizer(followTap)
        label.isUserInteractionEnabled = true
        
        return label
    }()
 
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        let followTap = UIGestureRecognizer(target: self,
                                            action: #selector(handleFollowingTapped))
        label.addGestureRecognizer(followTap)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    // MARK: - Lyfecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor,
                                left: leftAnchor,
                                paddingTop: -24,
                                paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor,
                                       right: rightAnchor,
                                       paddingTop: 12,
                                       paddingRight: 16)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullNameLabel,
                                                             userNameLabel,
                                                             bioLabel])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        
        addSubview(userDetailStack)
        userDetailStack.anchor(top: profileImageView.bottomAnchor,
                               left: leftAnchor,
                               right: rightAnchor,
                               paddingTop: 8,
                               paddingLeft: 12,
                               paddingRight: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         height: 50)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel,
                                                         followersLabel])
        followStack.axis = .horizontal
        followStack.distribution = .fillEqually
        followStack.spacing = 8
        
        addSubview(followStack)
        followStack.anchor(top: userDetailStack.bottomAnchor,
                           left: leftAnchor,
                           paddingTop: 8,
                           paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }

    @objc func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow()
    }
    
    // TODO: create followers tap action
    @objc func handleFollowersTapped() {}

    // TODO: create following tap action
    @objc func handleFollowingTapped() {}
    
    // MARK: - Helpers
    private func configure() {
        guard let user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        
        followingLabel.attributedText = viewModel.followingText
        followersLabel.attributedText = viewModel.followersText
        
        fullNameLabel.text = viewModel.fullNameText
        userNameLabel.text = viewModel.userNameText
        
        bioLabel.text = viewModel.bioText
    }
}

// MARK: - ProfileFilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect index: Int) {
        guard let filter = ProfileFilterOptions(rawValue: index) else { return }
        delegate?.didSelect(filter: filter)
    }
}
