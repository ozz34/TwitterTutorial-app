//
//  Utilities.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 17.01.2023.
//

import UIKit

class Utilities {
    
    func inputContainerView(with image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let iv = UIImageView()
        iv.image = image
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 8,
                         paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor,
                           bottom: view.bottomAnchor,
                           right: view.rightAnchor,
                           paddingLeft: 8,
                           height: 0.75)
    
        return view
    }
    
    func createTextField(withPlaceholder placeholder: String) -> UITextField {
         let tf = UITextField()
         tf.placeholder = placeholder
         tf.textColor = .white
         tf.font = UIFont.systemFont(ofSize: 16)
         tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
         
        return tf
    }
}

