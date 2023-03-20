//
//  RegistrationController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 16.01.2023.
//

import UIKit

final class RegistrationController: UIViewController {
    // MARK: - Properties
    private var profileImage: UIImage?
    private let imagePicker = UIImagePickerController()
    
    private lazy var plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "plus_photo")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self,
                         action: #selector(handleAddProfilePhoto),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(named: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(with: image ?? UIImage(),
                                                  textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(named: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(with: image ?? UIImage(),
                                                  textField: passwordTextField)
        return view
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let image = UIImage(named: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(with: image ?? UIImage(),
                                                  textField: fullNameTextField)
        return view
    }()
   
    private lazy var userNameContainerView: UIView = {
        let image = UIImage(named: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(with: image ?? UIImage(),
                                                  textField: userNameTextField)
        return view
    }()

    private let emailTextField: UITextField = {
        let tf = Utilities().createTextField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().createTextField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullNameTextField: UITextField = {
        let tf = Utilities().createTextField(withPlaceholder: "Full Name")
        return tf
    }()
    
    private let userNameTextField: UITextField = {
        let tf = Utilities().createTextField(withPlaceholder: "User Name")
        return tf
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.tintColor = .twitterBlue
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self,
                         action: #selector(handleRegistration),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = Utilities().createAttributeButton("Already have an account? ", "Log In")
        button.addTarget(self,
                         action: #selector(handleShowLogin),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRegistration() {
        guard let profileImage else {
            print("Debug: Please select a profile image")
            return
        }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let userName = userNameTextField.text?.lowercased() else { return }
        
        let authCredential = AuthCredentials(email: email,
                                             password: password,
                                             fullName: fullName,
                                             userName: userName,
                                             profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: authCredential) { [weak self] _, _ in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let tab = windowScene.windows.first?.rootViewController as? MainTabController else { return }
            tab.autenticateUserAndConfigureUI()
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true)
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .twitterBlue
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view,
                                topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusPhotoButton.setDimensions(width: 128, height: 128)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   fullNameContainerView,
                                                   userNameContainerView,
                                                   registrationButton])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 32,
                     paddingLeft: 32,
                     paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor,
                                        bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                        right: view.rightAnchor,
                                        paddingLeft: 40,
                                        paddingRight: 16)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal),
                                 for: .normal)
        plusPhotoButton.layer.cornerRadius = 128 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.clipsToBounds = true
        plusPhotoButton.contentMode = .scaleAspectFill
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3

        dismiss(animated: true)
    }
}
