//
//  MainTabController.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/07.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named:"new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleActionbuttonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    
    // MARK: - API
    
    /// 로그인 여부에 따른 UI 구분하는 기능
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            // 로그인 필요
            DispatchQueue.main.async {
                self.changeRootViewController(LoginController())
//                let nav = UINavigationController(rootViewController: LoginController())
//                nav.modalPresentationStyle = .overFullScreen
//                self.present(nav, animated: true, completion: nil)
            }
        } else {
            // 로그인
            configureViewController()
            configureUI()
            fetchUser()
        }
    }
    
    /// 유저 정보 가져오기
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    
    // MARK: - Selectors
    
    /// 우하단 버튼
    @objc func handleActionbuttonTapped() {
        guard let user = user else { return }
        let controller = UploadTweetController(user: user, config: .tweet)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    // UI 구성
    func configureUI() {
        // 우하단 버튼
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                            paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    
    // 탭 바 구성
    func configureViewController() {
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected")!, rootViewController: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected")!, rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected")!, rootViewController: notifications)
        
        let conversations = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1")!, rootViewController: conversations)
        
        viewControllers = [ nav1, nav2, nav3, nav4 ]
    }
    
    // 네비게이션 설정
    func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
    
}
