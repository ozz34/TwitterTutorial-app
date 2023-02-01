//
//  ProfileFilterView.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 31.01.2023.
//

import UIKit

protocol ProfileFilterViewDelegate: AnyObject {
    func filterView(_ view: UICollectionView, didSelect indexPath: IndexPath)
}

class ProfileFilterView: UIView {
    //MARK: -Properties
    private let identifier = "ProfileFilterCell"
    
    weak var delegate: ProfileFilterViewDelegate?
    
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    
    //MARK: -Lyfecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: identifier)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Helpers

}
//MARK: -UICollectionViewDataSource
extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ProfileFilterCell
            else { return UICollectionViewCell() }
        
        return cell
    }
}
//MARK: -UICollectionViewDelegateFlowLayout
extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
//MARK: -UICollectionViewDelegate
extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterView(self.collectionView, didSelect: indexPath)
    }
}

