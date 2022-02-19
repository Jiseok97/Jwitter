//
//  UserCell.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/19.
//

import UIKit

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    
    private lazy var profileImageView: UIImageView = {   // 유저 프로필 이미지
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 38, height: 38)
        iv.layer.cornerRadius = 38 / 2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private let usernameLabel: UILabel = {           // 게시글 Label
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "닉네임"
        return label
    }()
    
    private let fullnameLabel: UILabel = {           // 게시글 Label
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "이름"
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [ usernameLabel, fullnameLabel ])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
