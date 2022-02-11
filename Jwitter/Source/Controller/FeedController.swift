//
//  FeedController.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/07.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { configureLeftBarButton() }
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Functions
    
    func configureUI() {
        view.backgroundColor = .white
        
        /// 가운데 로고 이미지 뷰
        let logoView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        logoView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoView
        
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
