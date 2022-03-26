//
//  EditProfileOptions.swift
//  Jwitter
//
//  Created by 이지석 on 2022/03/27.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description: String {
        switch self {
        case .fullname: return "Name"
        case .username: return "Username"
        case .bio: return "Bio"
        }
    }
}
