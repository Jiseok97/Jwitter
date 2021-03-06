//
//  NotificationService.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/28.
//

import Firebase

struct NotificationService {
    /// 알림 서비스를 위한 싱글톤 객체
    static let shared = NotificationService()
    
    /// 알림을 업로드 하는 메서드
    func uploadNotification(toUser user: User,
                            type: NotificationType,
                            tweetID: String? = nil) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        if let tweetID = tweetID {
            values["tweetID"] = tweetID
        }
        
        REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
    }
    
    fileprivate func getNotifications(uid: String, completion: @escaping([Notification]) -> Void) {
        var notifications = [Notification]()
        
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            guard let dicitionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dicitionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notification(user: user, dictionary: dicitionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
    
    /// 알림 데이터 가져오는 메서드
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        let notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 유저 알림 데이터가 있는지 확인
        REF_NOTIFICATIONS.child(uid).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                // 유저의 알림 데이터 X
                completion(notifications)
            } else {
                getNotifications(uid: uid, completion: completion)
            }
        }
    }
}
