//
//  TweetController.swift
//  TwitterTutorial
//
//  Created by Иван Худяков on 06.02.2023.
//

import UIKit

class TweetController: UICollectionViewController {
    
    //MARK: -Properties
    private let tweet: Tweet
    private var replies = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let identifier = "TweetCell"
    private let headerIdentifier = "TweetHeader"
    
    //MARK: -Lyfecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        fetchReplies()
    }
    
    //MARK: -API
    func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { replies in
            self.replies = replies
        }
    }
  
    //MARK: -Helpers
    func configureCollectionView() {
       collectionView.backgroundColor = .white
   
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}

//MARK: - UICollectionViewDelegate
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath)
                as? TweetHeader else { return UICollectionReusableView() }
        header.tweet = tweet
      
        return header
    }
}

//MARK: - UICollectionViewDataSource
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TweetCell else { return UICollectionViewCell() }
        
        cell.tweet = replies[indexPath.row]
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TweetController: UICollectionViewDelegateFlowLayout {
   
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            let viewModel = TweetViewModel(tweet: tweet)
            let captionHeight = viewModel.size(forWidth: view.frame.width).height
            
            return CGSize(width: view.frame.width, height: captionHeight + 230)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            CGSize(width: view.frame.width, height: 120)
        }
}
