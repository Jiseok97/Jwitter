//
//  RegistrationController.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/08.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
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
    
    private lazy var fullnameContainerView: UIView = {
        let imageName = "ic_mail_outline_white_2x-1"
        let view = Utilites().inputContainerView(withImage: imageName, textField: fullnameTextField)
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let imageName = "ic_lock_outline_white_2x"
        let view = Utilites().inputContainerView(withImage: imageName, textField: usernameTextField)
        return view
    }()
    
    // 이메일 텍스트필드
    private let emailTextField: UITextField = {
        let tf = Utilites().textFeild(withPlaceholder: "이메일")
        return tf
    }()
    
    // 패스워드 텍스트필드
    private let passwordTextField: UITextField = {
        let tf = Utilites().textFeild(withPlaceholder: "패스워드")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    // 이름 텍스트필드
    private let fullnameTextField: UITextField = {
        let tf = Utilites().textFeild(withPlaceholder: "이름")
        return tf
    }()
    
    // 닉네임 텍스트필드
    private let usernameTextField: UITextField = {
        let tf = Utilites().textFeild(withPlaceholder: "닉네임")
        return tf
    }()
    
    // 회원가입 버튼
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilites().attributedButton("계정이 있으신가요?", " 로그인")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - Selector
    
    // 프로필 사진
    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // 회원가입 버튼
    @objc func handleRegistration() {
        guard let profileImage = profileImage else {
            print("프로필 이미지를 선택해주세요.")
            return
        }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        // 유저 이미지 및 회원 정보
        storageRef.putData(imageData, metadata: nil) {(meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    // 로그인 실패
                    if let error = error {
                        print("에러내역: \(error.localizedDescription)")
                        return
                    }
                    // 로그인 성공
                    guard let uid = result?.user.uid else { return }    // User ID
                    let values = [ "email": email,
                                   "username": username,
                                   "fullname": fullname,
                                   "profileImageUrl" : profileImageUrl ]
                    
                    REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
                        print("DEBUG: 유저 정보 업데이트를 성공했습니다.")
                    }
                    
                }
            }
        }
    }
    
    // 로그인 뷰 이동
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Functions
    
    func configureUI() {
        view.backgroundColor = .twitterBlue
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusPhotoButton.setDimensions(width: 128, height: 128)
        
        let stack = UIStackView(arrangedSubviews: [ emailContainerView,
                                                    passwordContainerView,
                                                    fullnameContainerView,
                                                    usernameContainerView,
                                                    registrationButton ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
}

// MARK: - Extension

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        
        plusPhotoButton.layer.cornerRadius = 128 / 2
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        
        /// withRenderingMode(.alwaysOriginal) → 렌더링 모드 속성과 함께 추가해줘야 함, 원본으로 설정, 이걸해줘야 선택한 사진이 적용됨
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
    
}
