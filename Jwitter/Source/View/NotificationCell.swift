//
//  NotificationCell.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/28.
//

import UIKit

protocol NotificationCellDelegate: class {
    /// 알림 탭 프로필 이미지 클릭 이벤트 처리 메서드
    func didTapProfileImage(_ cell: NotificationCell)
    /// 팔로우 알림 일 경우에 따른 버튼 가시화 처리 메서드
    func didTapFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var notification: Notification? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {   // 유저 프로필 이미지
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .twitterBlue
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private lazy var followButton: UIButton = {         // 알림창에 팔로우 버튼
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    let notificationLabel: UILabel = {                  // 알림 텍스트 표시 Label
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Some test notification message"
        return label
    }()
    
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [ profileImageView, notificationLabel ])
        stack.spacing = 8
        stack.alignment = .center
        
        contentView.addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        stack.anchor(right: rightAnchor, paddingRight: 12)
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(width: 92, height: 32)
        followButton.layer.cornerRadius = 32 / 2
        followButton.anchor(right: rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    @objc func handleFollowTapped() {
        delegate?.didTapFollow(self)
    }
    
    @objc func handleProfileImageTapped() {
        delegate?.didTapProfileImage(self)
    }
    
    // MARK: - Functions
    
    func configure() {
        guard let notification = notification else { return }
        let viewModel = NotificationViewModel(notification: notification)
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
        followButton.isHidden = viewModel.shouldHideFollowButton
        followButton.setTitle(viewModel.followButtonText, for: .normal)
    }
}
