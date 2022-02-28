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
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            REF_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else {
            
        }
    }
}
