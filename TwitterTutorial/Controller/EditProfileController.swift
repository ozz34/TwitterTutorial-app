//
//  EditProfileController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 17.02.2023.
//

import UIKit

// MARK: - EditProfileControllerDelegate
protocol EditProfileControllerDelegate: AnyObject {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
    func handleLogout()
}

final class EditProfileController: UITableViewController {
    // MARK: - Properties
    weak var delegate: EditProfileControllerDelegate?
    
    private var user: User
    
    private lazy var headerView = EditProfileHeader(user: user)
    private let identifier = "EditProfileCell"
    private let imagePicker = UIImagePickerController()
    private let footerView = EditProfileFooter()
   
    private var selectedImage: UIImage? {
        didSet {
            headerView.profileImageView.image = selectedImage
        }
    }
    
    private var userInfoChanged = false {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = userInfoChanged
        }
    }
    
    private var imageChanged = false {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = imageChanged
        }
    }
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        configureImagePicker()
    }
    
    // MARK: - API
    private func updateUserData() {
        if imageChanged && !userInfoChanged {
            updateProfileImage()
        }
        
        if !imageChanged && userInfoChanged {
            UserService.shared.saveUserData(user: user) { err, ref in
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        }
        
        if imageChanged && userInfoChanged {
            UserService.shared.saveUserData(user: user) { [weak self] err, ref in
                self?.updateProfileImage()
            }
        }
    }
    
    private func updateProfileImage() {
        guard let image = selectedImage else { return }
        
        UserService.shared.updateProfileImage(image: image) { profileImageURL in
            self.user.profileImageUrl = profileImageURL
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }

    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleDone() {
       view.endEditing(true)
       updateUserData()
    }
    
    // MARK: - Helpers
    private func configureNavigationBar() {

        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        headerView.delegate = self
        
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
        footerView.delegate = self
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: identifier)
    }
    
    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}

// MARK: - UITableViewDataSource
extension EditProfileController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? EditProfileCell else { return UITableViewCell()}
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EditProfileController {
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 100 : 48
    }
}

// MARK: - EditProfileHeaderDelegate
extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        present(imagePicker,animated: true)
    }
}

// MARK: - EditProfileFooterDelegate
extension EditProfileController: EditProfileFooterDelegate {
    func handleLogout() {
        let alert = UIAlertController(title: nil,
                                      message: "Are you sure you want to log out?",
                                      preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            self.dismiss(animated: true)
            self.delegate?.handleLogout()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(logOutAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

// MARK: - EditProfileCellDelegate
extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else { return }
        userInfoChanged = true

        switch viewModel.option {
        case .fullName:
            guard let fullName = cell.infoTextField.text else { return }
            user.fullName = fullName
        case .userName:
            guard let userName = cell.infoTextField.text else { return }
            user.userName = userName
        case .bio:
            user.bio = cell.bioTextView.text 
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        self.selectedImage = image
        imageChanged = true
        
        dismiss(animated: true)
    }
}
