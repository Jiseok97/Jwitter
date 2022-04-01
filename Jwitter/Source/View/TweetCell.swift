//
//  TweetCell.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/14.
//

import UIKit
import ActiveLabel

// class에서만 사용 가능하도록 설정
protocol TweetCellDelegate: class {
    /// 피드에 유저 프로필 이미지 클릭시 이벤트 처리 함수
    func handleProfileImageTapped(_ cell: TweetCell)
    /// 피드에 답장하는 메서드
    func handleReplyTapped(_ cell: TweetCell)
    /// 피드에 좋아요 이벤트 메서드
    func handleLikeTapped(_ cell: TweetCell)
    /// 맨션 클릭을 통한 유저 정보 가져오는 메서드
    func handleFetchUser(withUsername username: String)
}


class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var tweet: Tweet? {
        didSet { configure() }
    }
    
    // 순환참조를 피하기 위한 weak
    weak var delegate: TweetCellDelegate?
    
    private lazy var profileImageView: UIImageView = {   // 유저 프로필 이미지
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        // Image View엔 addTarget이 없어 제스처로 처리
        // 유저 상세 정보로 이동
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let replyLabel: ActiveLabel = {             // → replying to @Nickname (Label)
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.mentionColor = .twitterBlue
        return label
    }()
    
    private let captionLabel: ActiveLabel = {           // 게시글 Label
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    private let infoLabel = UILabel()             // 유저 닉네임 Label
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
//        // 프로필 이미지 Image View
//        addSubview(profileImageView)
//        profileImageView.anchor(top: topAnchor, left: leftAnchor,
//                                paddingTop: 8, paddingLeft: 8)
        
        // 유저 닉네임 및 게시글 Label
        let captionStack = UIStackView(arrangedSubviews: [ infoLabel, captionLabel ])
        captionStack.axis = .vertical
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 4
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [ profileImageView, captionStack ])
        imageCaptionStack.distribution = .fillProportionally
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [ replyLabel, imageCaptionStack ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
                     paddingTop: 4, paddingLeft: 12, paddingRight: 12)
        
        replyLabel.isHidden = true
        
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        
        // 댓글, 리트윗, 좋아요, 공유 버튼
        let actionStack = UIStackView(arrangedSubviews: [ commentButton, retweetButton, likeButton, shareButton ])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
        
        // 셀 경계선
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor,
                             right: rightAnchor, height: 1)
        
        configureMentionHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        print("DEBUG: Profile image Tapped self")
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleCommentTapped() {
        delegate?.handleReplyTapped(self)
    }
    
    @objc func handleRetweetTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(self)
    }
    
    @objc func handleShareTapped() {
        
    }
    
    
    // MARK: - Functions
    
    func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        infoLabel.attributedText = viewModel.userInfoText
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
       
        replyLabel.isHidden = viewModel.shouldHideReplyLabel                        // reply일 경우에 replyLabel이 보이도록
        replyLabel.text = viewModel.replyText
    }
    
    /// 버튼 구성 메서드
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    /// 태그 클릭 이벤트 메서드
    func configureMentionHandler() {
        captionLabel.handleMentionTap { username in
            self.delegate?.handleFetchUser(withUsername: username)
        }
    }
}
