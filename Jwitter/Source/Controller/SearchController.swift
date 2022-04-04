//
//  ExploreController.swift
//  Jwitter
//
//  Created by 이지석 on 2022/02/07.
//

import UIKit

private let reuseIdentifier = "UserCell"

enum SearchControllerConfiguration {
    case messages
    case userSearch
}

class SearchController: UITableViewController {
    
    // MARK: - Properties
    
    private let config: SearchControllerConfiguration
    
    private var users = [User]() {
        didSet { tableView.reloadData() }
    }
    
    private var filterdUsers = [User]() {
        didSet { tableView.reloadData() }
    }
    
    private var inSearchMode: Bool {
        // 검색창이 활성화되거나, 검색창에 텍스트가 존재하는 경우 Mode = true
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Life Cycle
    
    init(config: SearchControllerConfiguration) {
        self.config = config
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    
    /// 유저API 호출하여 유저 정보 가져오는 메서드
    func fetchUser() {
        UserService.shared.fetchUser { users in
            self.users = users
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = config == .messages ? "New Message" : "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        if config == .messages {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        }
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "유저 검색"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
}


// MARK: - UITableViewDelegate/DataSource

extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filterdUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        // 검색 모드인지 여부에 따라 데이터 차별화
        let user = inSearchMode ? filterdUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filterdUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    // 검색창에 텍스트가 입력될 때 마다 호출되는 메서드
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
//        guard let searchText = searchController.searchBar.text?.lowercased() else { return }  닉네임이 소문자로 시작하는 경우 넣어주기
        
        filterdUsers = users.filter({ $0.username.contains(searchText) })
    }
}
