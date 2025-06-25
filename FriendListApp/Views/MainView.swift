//
//  MainView.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/26.
//

import Foundation
import UIKit
// MARK: - MainView
class MainView: UIView {
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    let tabBarView = TabBarView()
    let navigationBarView = NavigationBarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .white
        
        [navigationBarView, pageViewController.view, tabBarView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // NavigationBarView 高度 = 狀態列高度 + 按鈕高度(24)
        let statusBarHeight = AppMetrics.statusBarHeight
        let navigationBarHeight = statusBarHeight + 24.scalePt()
        print("statusBarHeight", statusBarHeight, navigationBarHeight)
        
        NSLayoutConstraint.activate([
            // NavigationBarView 約束
            navigationBarView.topAnchor.constraint(equalTo: topAnchor), // 改為對齊 topAnchor 而非 safeAreaLayoutGuide
            navigationBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: navigationBarHeight),
            
            // TabBarView 約束
            tabBarView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 54.scalePt()),
            
            // PageViewController 約束 - 現在頂部對齊 NavigationBarView 底部
            pageViewController.view.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: tabBarView.topAnchor),
        ])
    }
}
