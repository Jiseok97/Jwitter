//
//  ExploreController.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/07.
//

import UIKit

class ExploreController: UIViewController {
    // MARK: - Properties
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Functions
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
    }
}
