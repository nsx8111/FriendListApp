//
//  FriendViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import UIKit

class FriendViewController: UIViewController {

    private let viewModel = FriendViewModel()
    private let friendListView = FriendListView()
    
    var currentType: MainContentType {
        return MainContentManager.shared.currentType
    }
    // 添加回調屬性，供 FriendChatPageViewController 監聽
    var onRequestRefresh: ((MainContentType) -> Void)?
    
    // 新增：搜索狀態變化回調
    var onSearchStateChanged: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView(for: currentType)
        setupEvents()
    }
    
    private func setupEvents() {
        friendListView.onRequestRefresh = { [weak self] type in
            self?.setupView(for: type)
            self?.onRequestRefresh?(type)
        }
        
        // 新增：設置搜索狀態變化回調
        friendListView.onSearchStateChanged = { [weak self] isSearching in
            self?.onSearchStateChanged?(isSearching)
        }
    }
    
    func setupView(for type: MainContentType) {
        [friendListView].forEach {
            $0.removeFromSuperview()
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let urls: [String]
        
        switch type {
        case .noFriend:
            urls = [apiDatasource5]
        case .noInvitations:
            urls = [apiDatasource2, apiDatasource3]
        case .invitedFriend:
            urls = [apiDatasource4]
        }
        
        view.addSubview(friendListView)
        NSLayoutConstraint.activate([
            friendListView.topAnchor.constraint(equalTo: view.topAnchor),
            friendListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        viewModel.fetchFriends(urls: urls) { [weak self] friends in
            DispatchQueue.main.async {
                self?.friendListView.updateFriendList(friends)
                self?.friendListView.endRefreshing()
            }
        }
    }
}
