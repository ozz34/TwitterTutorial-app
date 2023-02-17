//
//  EditProfileController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 17.02.2023.
//

import UIKit

protocol EditProfileControllerDelegate: AnyObject {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
}

class EditProfileController: UITableViewController {
    //MARK: -Properties
    private var user: User
    
    weak var delegate: EditProfileControllerDelegate?
    
    private lazy var headerView = EditProfileHeader(user: user)
    private let identifier = "EditProfileCell"
    private let imagePicker = UIImagePickerController()
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
    
    //MARK: -Lyfecycle
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureNavigationBar()
        configureTableView()
        configureImagePicker()
    }

    //MARK: -Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    @objc func handleDone() {
       updateUserData()
    }
    
    //MARK: -API
    func updateUserData() {
        UserService.shared.saveUserData(user: user) { err, ref in
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    //MARK: -Helpers
    
    func configureNavigationBar() {

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
    
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = UIView()
        headerView.delegate = self
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: identifier)
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}

//MARK: - UITableViewDataSource
extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? EditProfileCell else { return UITableViewCell()}
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        
        cell.delegate = self
 
        return cell
    }
}
//MARK: - UITableViewDelegate
extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 100 : 48
    }
}

//MARK: - EditProfileHeaderDelegate
extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        present(imagePicker,animated: true)
    }
}

//MARK: - EditProfileCellDelegate
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

//MARK: - UIImagePickerControllerDelegate
extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        
        dismiss(animated: true)
    }
}
