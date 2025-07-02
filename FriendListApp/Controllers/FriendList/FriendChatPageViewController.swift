//
//  FriendChatPageViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import Foundation
import UIKit

class FriendChatPageViewController: UIViewController {
    
    var viewModel = FriendChatPageViewModel()
    var friendChatPageView: FriendChatPageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPageViewController()
        setupEvent()
        setupGestureRecognizers()
        getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MainContentManager.shared.currentType == .invitedFriend {
            getInvitesData()
        }
        
        friendChatPageView.setNeedsLayout()
        friendChatPageView.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        friendChatPageView.inviteListView.setNeedsLayout()
        friendChatPageView.inviteListView.layoutIfNeeded()
    }
    // MARK: - Setup Methods
    
    private func setupView() {
        friendChatPageView = FriendChatPageView()
        view = friendChatPageView
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        if let navigationBar = navigationController?.navigationBar {
            let navTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            navTapGesture.cancelsTouchesInView = false
            navigationBar.addGestureRecognizer(navTapGesture)
        }
    }
    
    private func setupPageViewController() {
        addChild(friendChatPageView.pageViewController)
        friendChatPageView.pageViewController.didMove(toParent: self)
        friendChatPageView.pageViewController.dataSource = self
        friendChatPageView.pageViewController.delegate = self
        friendChatPageView.pageViewController.setViewControllers([viewModel.pages[0]], direction: .forward, animated: false)
    }
    
    private func setupEvent() {
        // 設置按鈕事件
        friendChatPageView.inviteListView.friendTabButton.addTarget(self, action: #selector(showFriendPage), for: .touchUpInside)
        friendChatPageView.inviteListView.chatTabButton.addTarget(self, action: #selector(showChatPage), for: .touchUpInside)
        
        // 設置高度變化回調
        friendChatPageView.inviteListView.heightDidChange = { [weak self] newHeight in
            self?.friendChatPageView.updateInviteListHeight(newHeight)
        }
        
        // 設置 FriendViewController 的 onRequestRefresh 回調
        if let friendViewController = viewModel.pages[0] as? FriendViewController {
            friendViewController.onRequestRefresh = { [weak self] type in
                if type == .invitedFriend {
                    self?.getInvitesData()
                }
            }
            // 設置搜索狀態變化回調
            friendViewController.onSearchStateChanged = { [weak self] isSearching in
                self?.friendChatPageView.handleSearchStateChange(isSearching)
            }
        }
    }
    
    // MARK: - Data Methods
    
    private func getUserData() {
        viewModel.friendViewModel.fetchUsers { [weak self] users in
            DispatchQueue.main.async {
                if let user = users.first {
                    print("使用者名稱：\(user.name)，KOKO ID：\(user.kokoid)")
                    self?.friendChatPageView.inviteListView.userName = user.name
                    self?.friendChatPageView.inviteListView.kokoID = user.kokoid
                }
            }
        }
    }
    
    private func getInvitesData() {
        viewModel.friendViewModel.fetchFriends(urls: [apiDatasource4]) { [weak self] friends in
            DispatchQueue.main.async {
                self?.friendChatPageView.inviteListView.updateInvitesList(friends) { [weak self] newHeight in
                    // 動態更新InviteList高度
                    self?.friendChatPageView.updateInviteListHeight(newHeight)
                }
            }
        }
    }
    
    // MARK: - Public Methods
    
    // 提供給外部調用的刷新方法
    func refreshData() {
        getUserData()
        
        if MainContentManager.shared.currentType == .invitedFriend {
            getInvitesData()
        }
        
        // 刷新當前顯示的頁面
        if let friendViewController = viewModel.pages[viewModel.currentIndex] as? FriendViewController {
            friendViewController.getFriendData(for: MainContentManager.shared.currentType)
        }
    }
    
    // MARK: - Action Methods
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func showFriendPage() {
        if viewModel.currentIndex != 0 {
            friendChatPageView.pageViewController.setViewControllers([viewModel.pages[0]], direction: .reverse, animated: true) { [weak self] completed in
                if completed {
                    self?.viewModel.currentIndex = 0
                    self?.friendChatPageView.inviteListView.setSelectedTab(index: 0)
                }
            }
        }
    }
    
    @objc private func showChatPage() {
        if viewModel.currentIndex != 1 {
            friendChatPageView.pageViewController.setViewControllers([viewModel.pages[1]], direction: .forward, animated: true) { [weak self] completed in
                if completed {
                    self?.viewModel.currentIndex = 1
                    self?.friendChatPageView.inviteListView.setSelectedTab(index: 1)
                }
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension FriendChatPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewModel.pages.firstIndex(of: viewController), index > 0 else { return nil }
        return viewModel.pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewModel.pages.firstIndex(of: viewController), index < (viewModel.pages.count - 1) else { return nil }
        return viewModel.pages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate

extension FriendChatPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = pageViewController.viewControllers?.first, let index = viewModel.pages.firstIndex(of: visibleVC) {
            viewModel.currentIndex = index
            friendChatPageView.inviteListView.setSelectedTab(index: viewModel.currentIndex)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        // 頁面切換時關閉鍵盤
        dismissKeyboard()
    }
}
