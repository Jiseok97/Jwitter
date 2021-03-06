//
//  UserService.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/11.
//

import UIKit
import Firebase

/// 팔로우/언팔로우 Completion
typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    /// 사용자 데이터 가져오는 API 싱글톤 객체
    static let shared = UserService()
    
    /// 사용자 데이터 가져오는 API
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    /// 탐색 페이지를 위한 유저 정보 가져오는 API
    func fetchUser(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    /// 유저 팔로우 기능
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    /// 유저 언팔로우 기능
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    /// 유저 팔로우 체크 기능
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        // 유저의 isFollowd가 다시 켜도 false로 설정이 되기 때문에 기존 true값을 유지하기 위한 기능
        // currentUid인 유저가 uid의 데이터를 가지고 있는지 여부 return
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    /// 유저의 팔로우/팔로잉 수 추출
    func fetchUserStatus(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
    
    /// 유저 프로필 이미지 업데이트 메서드
    func updateProfileImage(image: UIImage, completion: @escaping(URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let filename = NSUUID.init().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                let value = [ "profileImageUrl": profileImageUrl ]
                
                REF_USERS.child(uid).updateChildValues(value) { (err, ref) in
                    completion(url)
                }
            }
        }
    }
    
    
    /// 편집한 유저 정보 저장 메서드
    func saveUserData(user: User, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [ "fullname": user.fullname,
                       "username": user.username,
                       "bio": user.bio ?? "" ]
        
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    
    /// 태그를 통한 유저 정보 가져오는 메서드
    func fetchUser(withUsername username: String, completion: @escaping(User) -> Void) {
        REF_USER_USERNAME.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let uid = snapshot.value as? String else { return }
            self.fetchUser(uid: uid, completion: completion)
        }
    }
}
