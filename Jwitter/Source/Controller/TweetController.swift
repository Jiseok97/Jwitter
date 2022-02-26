//
//  TweetController.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/22.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "TweetHeader"

class TweetController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var tweet: Tweet
    private var actionSheetLauncher: ActionSheetLauncher!
    private var replies = [Tweet]() {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Life Cycle
    
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
    
    
    // MARK: - API
    
    func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { replies in
            self.replies = replies
        }
    }
    
    
    // MARK: - Functions
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(TweetHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
    }
    
    // Refactor → Extra to Method
    fileprivate func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.show()
        actionSheetLauncher.delegate = self
    }
    
}


// MARK: - UICollectionViewDataSource

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TweetHeader
        
        header.tweet = tweet
        header.delegate = self
        
        return header
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = TweetViewModel(tweet: tweet)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: captionHeight + 260)     // 헤더 높이
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}



// MARK: - TweetHeaderDelegate

extension TweetController: TweetHeaderDelegate {
    func showActinoSheet() {
        
        // 사용자 팔로우 여부를 파악한 뒤, 초기화
        if tweet.user.isCurrentUser {
            showActionSheet(forUser: tweet.user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { isFollowed in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
    }
}


// MARK: - ActionSheetLauncherDelegate

extension TweetController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        print("DEBUG: Option is controller is \(option.description)")
    }
}
