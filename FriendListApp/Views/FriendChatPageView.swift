//
//  FriendChatPageView.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/26.
//

import Foundation
import UIKit
// MARK: - FriendChatPageView
class FriendChatPageView: UIView {
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    let inviteListView = InviteListView()

    // 添加inviteList高度約束的變數
    private var inviteListHeightConstraint: NSLayoutConstraint!
    
    // 頁面視圖的top約束
    private var pageViewTopConstraint: NSLayoutConstraint!
    
    // InviteListView的原始高度
    private var originalInviteListHeight: CGFloat = 137.scalePt()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .white
        
        [inviteListView, pageViewController.view].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // 使用變數儲存高度約束
        inviteListHeightConstraint = inviteListView.heightAnchor.constraint(equalToConstant: originalInviteListHeight)
        
        // 設置頁面視圖的top約束
        pageViewTopConstraint = pageViewController.view.topAnchor.constraint(equalTo: inviteListView.bottomAnchor)

        NSLayoutConstraint.activate([
            inviteListView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            inviteListView.leadingAnchor.constraint(equalTo: leadingAnchor),
            inviteListView.trailingAnchor.constraint(equalTo: trailingAnchor),
            inviteListHeightConstraint,
 
            pageViewTopConstraint,
            pageViewController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    
    // 更新InviteList高度
    func updateInviteListHeight(_ newHeight: CGFloat) {
        inviteListHeightConstraint.constant = newHeight
        originalInviteListHeight = newHeight
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    // 處理搜索狀態變化
    func handleSearchStateChange(_ isSearching: Bool) {
        if isSearching {
            pageViewTopConstraint.constant = -originalInviteListHeight
        } else {
            // 當結束搜索時，恢復原始位置
            pageViewTopConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
