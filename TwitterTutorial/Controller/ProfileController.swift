//
//  ProfileController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 30.01.2023.
//

import UIKit

class ProfileController: UICollectionViewController {
    //MARK: -Properties
    private let identifier = "TweetCell"
    private let headerIdentifier = "ProfileHeader"
    
    //MARK: -Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: -Selectors
    
   
    //MARK: -Helpers
    
    func configureCollectionView() {
    collectionView.contentInsetAdjustmentBehavior = .never
        
    collectionView.register(TweetCell.self, forCellWithReuseIdentifier: identifier)
    collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
    }
}

// MARK: -UICollectionViewDataSource
extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TweetCell
            else { return UICollectionViewCell() }
        
        return cell
    }
}
// MARK: -UICollectionViewDelegate
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath)
                as? ProfileHeader else { return UICollectionReusableView() }
        
        return header
    }
}

// MARK: -UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 120)
    }
}
