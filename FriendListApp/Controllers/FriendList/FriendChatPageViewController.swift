//
//  FriendChatPageViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import Foundation
import UIKit

class FriendChatPageViewController: UIViewController {
    
    private let viewModel = FriendViewModel()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let inviteListView = InviteListView()

    // 添加inviteList高度約束的變數
    private var inviteListHeightConstraint: NSLayoutConstraint!
    
    // 新增：頁面視圖的top約束
    private var pageViewTopConstraint: NSLayoutConstraint!
    
    // 新增：InviteListView的原始高度
    private var originalInviteListHeight: CGFloat = 192.scalePt()

    private lazy var pages: [UIViewController] = {
        return [FriendViewController(), ChatViewController()]
    }()

    private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        setupPageViewController()
        setupEvents()
        getUserData()
        
        if MainContentManager.shared.currentType == .invitedFriend {
            getInvitesData()
        }
        
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 每次進入頁面時檢查是否需要更新邀請資料
        if MainContentManager.shared.currentType == .invitedFriend {
            getInvitesData()
        }
    }
    
    // MARK: - Setup Methods
    
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
    
    private func setupLayout() {
        [inviteListView, pageViewController.view].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // 使用變數儲存高度約束
        inviteListHeightConstraint = inviteListView.heightAnchor.constraint(equalToConstant: originalInviteListHeight)
        
        // 設置頁面視圖的top約束
        pageViewTopConstraint = pageViewController.view.topAnchor.constraint(equalTo: inviteListView.bottomAnchor)

        NSLayoutConstraint.activate([
            inviteListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inviteListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inviteListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inviteListHeightConstraint,
 
            pageViewTopConstraint,
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        inviteListView.friendTabButton.addTarget(self, action: #selector(showFriendPage), for: .touchUpInside)
        inviteListView.chatTabButton.addTarget(self, action: #selector(showChatPage), for: .touchUpInside)
    }
    
    private func setupPageViewController() {
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false)
    }
    
    private func setupEvents() {
        // 設置高度變化回調
        inviteListView.heightDidChange = { [weak self] newHeight in
            self?.updateInviteListHeight(newHeight)
        }
        
        // 設置 FriendViewController 的 onRequestRefresh 回調
        if let friendViewController = pages[0] as? FriendViewController {
            friendViewController.onRequestRefresh = { [weak self] type in
                // 當 type 為 invitedFriend 時執行 getInvitesData
                if type == .invitedFriend {
                    self?.getInvitesData()
                }
            }
            
            // 新增：設置搜索狀態變化回調
            friendViewController.onSearchStateChanged = { [weak self] isSearching in
                self?.handleSearchStateChange(isSearching)
            }
        }
    }
    
    // MARK: - Data Methods
    
    private func getUserData() {
        viewModel.fetchUsers { [weak self] users in
            DispatchQueue.main.async {
                if let user = users.first {
                    print("使用者名稱：\(user.name)，KOKO ID：\(user.kokoid)")
                    self?.inviteListView.userName = user.name
                    self?.inviteListView.kokoID = user.kokoid
                }
            }
        }
    }
    
    private func getInvitesData() {
        viewModel.fetchFriends(urls: [apiDatasource4]) { [weak self] friends in
            DispatchQueue.main.async {
                self?.inviteListView.updateInvitesList(friends) { [weak self] newHeight in
                    // 動態更新InviteList高度
                    self?.updateInviteListHeight(newHeight)
                }
            }
        }
    }
    
    // MARK: - UI Update Methods
    
    // 更新InviteList高度
    private func updateInviteListHeight(_ newHeight: CGFloat) {
        inviteListHeightConstraint.constant = newHeight
        originalInviteListHeight = newHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 新增：處理搜索狀態變化
    private func handleSearchStateChange(_ isSearching: Bool) {
        if isSearching {
            pageViewTopConstraint.constant = -originalInviteListHeight
        } else {
            // 當結束搜索時，恢復原始位置
            pageViewTopConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Public Methods
    
    // 提供給外部調用的刷新方法
    func refreshData() {
        getUserData()
        
        if MainContentManager.shared.currentType == .invitedFriend {
            getInvitesData()
        }
        
        // 刷新當前顯示的頁面
        if let friendViewController = pages[currentIndex] as? FriendViewController {
            friendViewController.setupView(for: MainContentManager.shared.currentType)
        }
    }
    
    // MARK: - Action Methods
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func showFriendPage() {
        if currentIndex != 0 {
            pageViewController.setViewControllers([pages[0]], direction: .reverse, animated: true) { [weak self] completed in
                if completed {
                    self?.currentIndex = 0
                    self?.inviteListView.setSelectedTab(index: 0)
                }
            }
        }
    }
    
    @objc private func showChatPage() {
        if currentIndex != 1 {
            pageViewController.setViewControllers([pages[1]], direction: .forward, animated: true) { [weak self] completed in
                if completed {
                    self?.currentIndex = 1
                    self?.inviteListView.setSelectedTab(index: 1)
                }
            }
        }
    }
}

// MARK: - UIPageView

// MARK: - UIPageViewControllerDataSource

extension FriendChatPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < (pages.count - 1) else { return nil }
        return pages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate

extension FriendChatPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: visibleVC) {
            currentIndex = index
            inviteListView.setSelectedTab(index: currentIndex)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        // 頁面切換時關閉鍵盤
        dismissKeyboard()
    }
}
