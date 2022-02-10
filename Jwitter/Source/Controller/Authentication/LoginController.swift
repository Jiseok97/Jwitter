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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilites().attributedButton("계정이 없으신가요?", " 회원가입")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selector
    
    // 회원가입 버튼 클릭
    @objc func handleShowSignUp() {
        let signVC = RegistrationController()
        navigationController?.pushViewController(signVC, animated: true)
    }
    
    
    // 로그인 버튼 클릭
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.shared.logUserInt(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("로그인 에러: \(error)")
                return
            }
            
//            guard let windows = UIApplication.shared.connectedScenes.first(where: { $0.})
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tab = window.rootViewController as? MainTabController else { return }
            // 로그인이 되었을 때, MainTabController에 있는 UI function 실행시키기
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Functions
    
    func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        // 이미지 뷰
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        // 스택뷰([이메일,패스워드]텍스트 필드 & 로그인 버튼)
        let stack = UIStackView(arrangedSubviews: [ emailContainerView, passwordContainerView, loginButton ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingLeft: 32, paddingRight: 32)
        
        // 회원가입 버튼 설정
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
}
