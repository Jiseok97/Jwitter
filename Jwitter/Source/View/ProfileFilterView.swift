//
//  ProfileFilterView.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/15.
//

import UIKit

private let reuseIdentifier = "ProfileFilterCell"

/// 필터 클릭시 이벤트 조정을 위한 프로토콜
protocol ProfileFilterViewDelegate: class {
    /// Collection View didSelectItemAt 이용
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath)
}

class ProfileFilterView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ProfileFilterViewDelegate?
    
    lazy var collectionView: UICollectionView = {       // 필터 Collection View
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let underlineView: UIView = {               // 필터 탭 누를 때 따라다니는 아래 애니메이션 뷰
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // 처음 자동으로 indexPath.row → 0이 되게 설정
        let seletedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: seletedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    override func layoutSubviews() {
        // init에 Frame.width = 0, Frame이 잡히기전에 생성이 되므로, layout subview를 통해 Frame이 잡히고
        // underlineView를 넣어 주었다.
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UICollctionViewDataSource

extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileFilterCell
        
        let option = ProfileFilterOptions(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(ProfileFilterOptions.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Underline View 애니메이션
        let cell = collectionView.cellForItem(at: indexPath)
        let xPostion = cell?.frame.origin.x ?? 0
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPostion
        }
        
        delegate?.filterView(self, didSelect: indexPath)
    }
}
