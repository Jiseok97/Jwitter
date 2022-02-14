//
//  TweetCell.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/14.
//

import UIKit

class TweetCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
