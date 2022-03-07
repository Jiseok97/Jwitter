//
//  ProfileController.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/15.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
        
    // MARK: - Properties
    
    private var user: User
    
    private var selectedFilter: ProfileFilterOptions = .tweets {        // 유저가 선택한 탭 Type 변수
        didSet { collectionView.reloadData() }
    }
    
    private var tweets = [Tweet]()                                      // 일반 트윗 탭
    private var replies = [Tweet]()                                     // 트윗 & 답장 탭
    private var likedTweets = [Tweet]()                                 // 좋아한 트윗 탭
    
    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets: return tweets
        case .replies: return replies
        case .likes: return likedTweets
        }
    }
    
    // MARK: - Life Cycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())      // Profile Controller → UICollectionViewController 떄문에
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureColletionView()
        fetchTweets()
        fetchLikedTweets()
        checkIfUserIsFollowed()
        fetchUserStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black
        // AppDelegate에서 15 버전 업데이트 네비게이션 바 대응 설정으로 인해
        // 상태표시줄 흰색 변경이 힘들어보임, 대체 방법 구축하기
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - API
    /// 트윗 데이터 가져오기
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    /// 좋아한 트윗 데이터 가져오기
    func fetchLikedTweets() {
        TweetService.shared.fetchLikes(forUser: user) { tweets in
            self.likedTweets = tweets
        }
    }
    
    /// 유저 팔로우 여부 체크 기능 및 UI 업데이트
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    /// 유저의 팔로우/팔로잉 데이터 가져오기
    func fetchUserStatus() {
        UserService.shared.fetchUserStatus(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Functions
    
    func configureColletionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never              // 상태표시줄 여백 없애기
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
    }
}


// MARK: - UICollectionViewDelegate

extension ProfileController {
    // 위 설정에서 kind는 header로 설정해둠
    // Apple → Collection View에 표시할 supplementary(보조) View를 제공하도록 데이터 원본 개체에 요청합니다
    // configure header ▾
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}


// MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        
        cell.tweet = currentDataSource[indexPath.row]
        
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)     // 헤더 높이
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}


// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        // 본인 계정일 경우에도 팔로우 기능이 되기 때문에 수정하기 위한 if문
        if user.isCurrentUser {
            return
        }
        
        if user.isFollowed {
            /// 유저 언팔로우
            UserService.shared.unfollowUser(uid: user.uid) { (err, ref) in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            /// 유저 팔로우
            UserService.shared.followUser(uid: user.uid) { (err, ref) in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(type: .follow, user: self.user)
            }
        }
    }
    
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
}
