//
//  UploadTweetController.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/12.
//

import UIKit

class UploadTweetController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    // MARK: - Seletor
    /// Cancel 버튼 클릭 이벤트
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    /// Tweet 버튼 클릭 이벤트
    @objc func handleUploadTweet() {
        print("DEBUG: Tweet button Tapped")
    }
    
    
    // MARK: - API
    
    
    // MARK: - Functions
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}

