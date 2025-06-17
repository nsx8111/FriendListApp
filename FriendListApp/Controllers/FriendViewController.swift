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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView(for: currentType)
        
        friendListView.onRequestRefresh = { [weak self] type in
            self?.setupView(for: type)
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
            urls = ["https://dimanyen.github.io/friend4.json"]
        case .noInvitations:
            urls = ["https://dimanyen.github.io/friend1.json", "https://dimanyen.github.io/friend2.json"]
        case .invitedFriend:
            urls = ["https://dimanyen.github.io/friend3.json"]
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
