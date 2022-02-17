//
//  ProfileHeaderViewModel.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/16.
//

import Foundation
import UIKit

// 프로필 필터 버튼 이름 설정
// CaseIterable(protocol): 모든 case 값들에 대한 컬렉션을 제공하는 타입
enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}


struct ProfileHeaderViewModel {
    
    private let user: User
    
    var followerString: NSAttributedString? {
        return attributedText(withValue: 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: 2, text: "following")
    }
    
    init(user: User) {
        self.user = user
    }
    
    /// 팔로우,팔로잉 텍스트 UI 설정
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
}
