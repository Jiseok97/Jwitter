//
//  TweetService.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/14.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [ "uid" : uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes" : 0,
                      "retweets": 0,
                      "caption": caption] as [String : Any]
        
        // 써야할 메소드의 completion을 매개변수 completion에 미리 선언
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    
    /// 트윗 데이터 가져오는 함수
    func feetchTwetts(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dicitionary = snapshot.value as? [String: Any] else { return }
            let tweetID = snapshot.key
            let tweet = Tweet(tweetID: tweetID, dictionary: dicitionary)
            tweets.append(tweet)
            completion(tweets)
        }
    }
}
