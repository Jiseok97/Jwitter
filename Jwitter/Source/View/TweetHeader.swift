//
//  TweetHeader.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/22.
//

import UIKit
import ActiveLabel

protocol TweetHeaderDelegate: class {
    func showActinoSheet()
    func handleFetchUser(withUsername username: String)
}

class TweetHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    // 트윗으로 초기화되므로 트윗 데이터가 유지될 수 있도록 보장하기 위한 Property
    var tweet: Tweet? {
        didSet { configure() }
    }
    
    weak var delegate: TweetHeaderDelegate?
    
    private lazy var profileImageView: UIImageView = {   // 유저 프로필 이미지
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let fullnameLabel: UILabel = {              // 유저 이름 Label
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Jiseok"
        return label
    }()
    
    private let usernameLabel: UILabel = {              // 유저 닉네임 Label
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let captionLabel: ActiveLabel = {               // 트윗 내용 Label
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        return label
    }()
    
    private let dateLabel: UILabel = {                  // 트윗 날짜 Label
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var optionsButton: UIButton = {        // 액션 시트 보이는 옵션 Button
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private let replyLabel: ActiveLabel = {             // → replying to @Nickname (Label)
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.mentionColor = .twitterBlue
        
        return label
    }()
    
    private lazy var retweetsLabel = UILabel()          // 리트윗 Lable
    private lazy var likesLabel = UILabel()             // 좋아요 Label
    
    private lazy var stacksView: UIView = {             // 구분선, 리트윗, 좋아요 Label, 구분선 Stack View
        let view = UIView()
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [ retweetsLabel, likesLabel ])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        return view
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
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelStack = UIStackView(arrangedSubviews: [ fullnameLabel, usernameLabel ])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [ profileImageView, labelStack ])
        imageCaptionStack.spacing = 12
        
        let stack = UIStackView(arrangedSubviews: [ replyLabel, imageCaptionStack ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor,
                            paddingTop: 12, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stack)
        optionsButton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(stacksView)
        stacksView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, height: 40)
        
        let actionStack = UIStackView(arrangedSubviews: [ commentButton, retweetButton, likeButton, shareButton ])
        actionStack.spacing = 72
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(top: stacksView.bottomAnchor, paddingTop: 12)
        
        configureMentionHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    /// 프로필 사진 클릭 이벤트
    @objc func handleProfileImageTapped() {
        print("DEBUG: 프로필 이미지 클릭")
    }
    
    /// 옵션 버튼 클릭 시 나오는 Action Sheet 이벤트
    @objc func showActionSheet() {
        delegate?.showActinoSheet()
    }
    
    /// 댓글 달기 버튼 클릭 이벤트
    @objc func handleCommentTapped() {
        
    }
    
    /// 리트윗 버튼 클릭 이벤트
    @objc func handleRetweetTapped() {
        
    }
    
    /// 좋아요 버튼 클릭 이벤트
    @objc func handleLikeTapped() {
        
    }
    
    /// 공유 버튼 클릭 이벤트
    @objc func handleShareTapped() {
        
    }
    
    // MARK: - Functions
    
    func configure() {
        guard let tweet = tweet else { return }
        
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        dateLabel.text = viewModel.headerTimestamp
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        retweetsLabel.attributedText = viewModel.retweetsAtrributedString
        likesLabel.attributedText = viewModel.likesAttributedString
        
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
    
    /// 트윗 아래 버튼 구성 메서드
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
