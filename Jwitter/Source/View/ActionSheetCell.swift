//
//  ActionSheetCell.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/25.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    
    // MARK: - Properties
    
    var option: ActionSheetOptions? {
        didSet { configure() }
    }
    
    private let optionImageView: UIImageView = {                        // Actino Sheet 아이콘 Image View
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "twitter_logo_blue")
        return iv
    }()
    
    private let titleLabel: UILabel = {                                 // Action Sheet 이름 Label
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test Option"
        return label
    }()
    
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.anchor(left: leftAnchor,  paddingLeft: 8)
        optionImageView.setDimensions(width: 36, height: 36)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImageView.rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configure() {
        titleLabel.text = option?.description
    }
}
