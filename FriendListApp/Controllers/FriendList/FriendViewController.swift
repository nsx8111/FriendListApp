//
//  FriendViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import UIKit

class FriendViewController: UIViewController {

    var viewModel = FriendViewModel()
    var friendListView: FriendListView!
    
    var currentType: MainContentType {
        return MainContentManager.shared.currentType
    }
    
    // 添加回調屬性，供 FriendChatPageViewController 監聽
    var onRequestRefresh: ((MainContentType) -> Void)?
    
    // 搜索狀態變化回調
    var onSearchStateChanged: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getFriendData(for: currentType)
        setupEvent()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        friendListView = FriendListView()
        view = friendListView
    }
    
    private func setupEvent() {
        friendListView.onRequestRefresh = { [weak self] type in
            self?.getFriendData(for: type)
            self?.onRequestRefresh?(type)
        }
        
        // 設置搜索狀態變化回調
        friendListView.onSearchStateChanged = { [weak self] isSearching in
            self?.onSearchStateChanged?(isSearching)
        }
    }
    
    // MARK: - Public Methods
    
    func getFriendData(for type: MainContentType) {
        let urls = getURLs(for: type)
        viewModel.fetchFriends(urls: urls) { [weak self] friends in
            DispatchQueue.main.async {
                self?.friendListView.updateFriendList(friends)
                self?.friendListView.endRefreshing()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func getURLs(for type: MainContentType) -> [String] {
        switch type {
        case .noFriend:
            return [apiDatasource5]
        case .noInvitations:
            return [apiDatasource2, apiDatasource3]
        case .invitedFriend:
            return [apiDatasource4]
        }
    }
}
