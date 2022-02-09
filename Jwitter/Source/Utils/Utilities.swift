//
//  Utilities.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/08.
//

import UIKit

class Utilites {
    // MARK: - 로그인 뷰 텍스트필드 (이메일, 패스워드)
    func inputContainerView(withImage imageName: String, textField: UITextField) -> UIView{
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // 이미지 뷰
        let iv = UIImageView()
        iv.image = UIImage(named: imageName)
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        // 텍스트필드
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                        paddingLeft: 8, paddingBottom: 8)
        
        // 텍스트필드 밑줄
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                           paddingLeft: 8, height: 0.75)
        
        return view
    }
    
    
    // MARK: - 텍스트 필드 설정
    func textFeild(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
         tf.placeholder = placeholder
         tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
         return tf
    }
    
    
    // MARK: - 로그인 및 회원가입 버튼 글씨 설정
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart,
                                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                                                                     NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSMutableAttributedString(string: secondPart,
                               attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                               NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
    
}
