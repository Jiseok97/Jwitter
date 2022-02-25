//
//  ActionSheetLauncher.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/25.
//

import Foundation

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    
    private let user: User
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    // MARK: - Functinos
    
    func show() {
        print("DEBUG: Show action sheet for user \(user.username)")
    }
}
