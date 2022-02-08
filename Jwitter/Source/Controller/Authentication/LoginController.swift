//
//  LoginController.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/08.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    private let logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "TwitterLogo")    // Image Literal 안되는 이유.. 버전 차이
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let imageName = "ic_mail_outline_white_2x-1"
        let view = Utilites().inputContainerView(withImage: imageName, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let imageName = "ic_lock_outline_white_2x"
        let view = Utilites().inputContainerView(withImage: imageName, textField: passwordTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilites().textFeild(withPlaceholder: "이메일")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilites().textFeild(withPlaceholder: "패스워드")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selector
    
    
    // MARK: - Functions
    
    func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        // 이미지 뷰
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        // 스택뷰(이메일, 패스워드 뷰)
        let stack = UIStackView(arrangedSubviews: [ emailContainerView, passwordContainerView ])
        stack.axis = .vertical
        stack.spacing = 8
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingLeft: 16, paddingRight: 32)
    }
}
