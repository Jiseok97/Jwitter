//
//  TweetService.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/14.
//

import Firebase
import UIKit

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [ "uid" : uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes" : 0,
                      "retweets": 0,
                      "caption": caption] as [String : Any]
        
        let ref = REF_TWEETS.childByAutoId()
        
        // 써야할 메소드의 completion을 매개변수 completion에 미리 선언
        ref.updateChildValues(values) { (err, ref) in
            // 트윗 업로드가 완료된 후 사용자 트윗 구조를 업데이트
            guard let tweetID = ref.key else { return }
            REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
        }
    }
    
    
    /// 트윗 데이터 가져오는 함수
    func feetchTwetts(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dicitionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dicitionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dicitionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    /// 해당 유저의 트윗 데이터 가져오는 함수
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dicitionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dicitionary["uid"] as? String else { return }
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dicitionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
}
