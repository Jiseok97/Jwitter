//
//  ActionSheetViewModel.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/25.
//

import Foundation

struct ActionSheetViewModel {
    
    private let user: User
    
    var option: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {                         // 내 프로필일 경우
            results.append(.delete)
        } else {                                        // 팔로우, 언팔로우 여부에 따른 데이터 추가
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        results.append(.report)
        
        return results
    }
    
    init(user: User) {
        self.user = user
    }
}

/// 옵션을 모델링하기 위한 Enum
enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String {
        switch self {
        case .follow(let user): return "Follow @\(user.username)"
        case .unfollow(let user): return "Unfollow @\(user.username)"
        case .report: return "Report Tweet"
        case .delete: return "Delete Tweet"
        }
    }
}
