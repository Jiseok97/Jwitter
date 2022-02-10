//
//  AuthService.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/10.
//

import UIKit
import Firebase

/// 회원가입에 필요한 정보들
struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    // Singleton
    static let shared = AuthService()
    
    /// 회원 등록하기
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) {(meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    // 로그인 실패
                    if let error = error {
                        print("에러내역: \(error.localizedDescription)")
                        return
                    }
                    // 로그인 성공
                    guard let uid = result?.user.uid else { return }    // User ID
                    let values = [ "email": email,
                                   "username": username,
                                   "fullname": fullname,
                                   "profileImageUrl" : profileImageUrl ]

                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                    
                }
            }
        }
    }
}
