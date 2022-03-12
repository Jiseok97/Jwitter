//
//  TweetViewModel.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/15.
//

import UIKit

struct TweetViewModel {
    
    // MARK: - Propeties
    
    let tweet: Tweet
    let user: User
    
    var profileImageUrl: URL? {
        return tweet.user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [ .second, .minute, .hour, .day, .weekOfMonth ]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
    }
    
    /// TweetHeader 사용될 ViewModel 메서드
    var usernameText: String {
        return "@\(user.username)"
    }
    
    /// 트윗 시간 Label 구성 메서드
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a ∙ MM/dd/yyyy"
//        formatter.dateFormat = "yyyy년MM월dd일 ∙ a hh:mm"
        return formatter.string(from: tweet.timestamp)
    }
    
    /// 트윗 게시물 → 리트윗 표시 Label 구성 메서드
    var retweetsAtrributedString: NSAttributedString? {
        return attributedText(withValue: tweet.retweetCount, text: "Retweets")
    }
    
    /// 트윗 게시물 → 좋아요 표시 Label 구성 메서드
    var likesAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: "Likes")
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname,
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @/\(user.username)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " • \(timestamp)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        
        return title
    }
    
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? .red : .darkGray
    }
    
    var likeButtonImage: UIImage {
        let imageName = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    var shouldHideReplyLabel: Bool {                // reply일 경우 보이도록 || reply가 아니면 안보이도록
        return !tweet.isReply
    }
    
    var replyText: String? {
        guard let replyingToUsername = tweet.replyingTo else { return nil }
        return "→ replying to @\(replyingToUsername)"
    }
    
    // MARK: - Life Cycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
    
    
    /// 해당 텍스트의 크기나 프레임을 파악한 다음 사이즈 지정해주는 메서드
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping                                        // 단어 기준으로 줄바꿈
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false                      // 자동 리사이징 기능 x
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)     // 최소한의 크기 지정
    }
}
