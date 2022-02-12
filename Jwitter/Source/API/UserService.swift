//
//  UserService.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/11.
//

import Firebase

struct UserService {
    /// 사용자 데이터 가져오는 API 싱글톤 객체
    static let shared = UserService()
    
    /// 사용자 데이터 가져오는 API
    func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}
