//
//  EditProfileCell.swift
//  Jwitter
//
//  Created by 이지석 on 2022/03/27.
//

import UIKit

class EditProfileCell: UITableViewCell {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
}
