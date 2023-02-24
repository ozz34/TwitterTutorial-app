//
//  EditProfileCell.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 17.02.2023.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    //MARK: -Properties
    var viewModel: EditProfileViewModel? {
        didSet {
            configure()
        }
    }
    weak var delegate: EditProfileCellDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)

        return label
    }()
    
    lazy var infoTextField: UITextField = {
       let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.textColor = .twitterBlue
        tf.addTarget(self,
                     action: #selector(handleUpdateUserInfo),
                     for: .editingDidEnd)
        
        return tf
    }()
    
    let bioTextView: InputTextView = {
        let tv = InputTextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .twitterBlue
        
        return tv
    }()

    //MARK: -Lyfecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
       
        contentView.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor,
                          left: leftAnchor,
                          paddingTop: 12,
                          paddingLeft: 16)
        
        contentView.addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor,
                             left: titleLabel.rightAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: 4,
                             paddingLeft: 16,
                             paddingRight: 8)
        
        contentView.addSubview(bioTextView)
        bioTextView.anchor(top: topAnchor,
                           left: titleLabel.rightAnchor,
                           bottom: bottomAnchor,
                           right: rightAnchor,
                           paddingTop: 4,
                           paddingLeft: 14,
                           paddingRight: 8)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleUpdateUserInfo),
                                               name: UITextView.textDidEndEditingNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Selectors
    @objc func handleUpdateUserInfo() {
        delegate?.updateUserInfo(self)
    }

    //MARK: -Helpers
    private func configure() {
        guard let viewModel else { return }
        
        bioTextView.isHidden = viewModel.shouldHideTextView
        titleLabel.text = viewModel.titleText
        
        infoTextField.isHidden = viewModel.shouldHideTextField
        infoTextField.text = viewModel.optionValue
        
        bioTextView.placeholderLabel.isHidden = viewModel.shouldHidePlaceholderLabel
        bioTextView.text = viewModel.optionValue
    }
}
