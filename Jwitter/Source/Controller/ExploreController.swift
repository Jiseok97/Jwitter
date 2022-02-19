//
//  ExploreController.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/07.
//

import UIKit

private let reuseIdentifier = "UserCell"

class ExploreController: UITableViewController {
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
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
}


// MARK: - UITableViewDelegate

extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        
        return cell
    }
}
