//
//  FeedController.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/07.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { configureLeftBarButton() }
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
    
    // MARK: - API
    
    func fetchTweets() {
        TweetService.shared.feetchTwetts { tweets in
            print("DEBUG: tweets = \(tweets)")
        }
    }
    
    
    // MARK: - Functions
    
    func configureUI() {
        view.backgroundColor = .white
        
        // Cell 등록
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        /// 가운데 로고 이미지 뷰
        let logoView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        logoView.contentMode = .scaleAspectFit
        logoView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = logoView
        
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

// MARK: - Extension
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        
        return cell
    }
    
}


// MARK: - UICollectionView Delegate
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}
