//
//  ProfileHeaderViewModel.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/16.
//

import Foundation

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
