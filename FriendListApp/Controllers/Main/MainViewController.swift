//
//  MainViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let tabBarView = TabBarView()
    private let navigationBarView = NavigationBarView()

    private lazy var pages: [UIViewController] = {
        return [
            MoneyViewController(),
            FriendChatPageViewController(),
            KOKOViewController(),
            AccountingViewController(),
            SettingViewController()
        ]
    }()
    
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first {
            let statusBarHeight = window.safeAreaInsets.top
            print("狀態列高度: \(statusBarHeight)")
        }

        setupLayout()
        setupPageViewController()
        
        tabBarView.onTabSelected = { [weak self] index in
            self?.switchToPage(index: index)
        }
    }
    
    private func setupLayout() {
        
        [navigationBarView, pageViewController.view, tabBarView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 計算狀態列高度
        let statusBarHeight: CGFloat
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first {
            statusBarHeight = window.safeAreaInsets.top
        } else {
            statusBarHeight = 44 // 預設值
        }
        
        // NavigationBarView 高度 = 狀態列高度 + 按鈕高度(24)
        let navigationBarHeight = statusBarHeight + 24.scalePt()
        
        NSLayoutConstraint.activate([
            // NavigationBarView 約束
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor), // 改為對齊 view.topAnchor 而非 safeAreaLayoutGuide
            navigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: navigationBarHeight),
            
            // TabBarView 約束
            tabBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 54.scalePt()),
            
            // PageViewController 約束 - 現在頂部對齊 NavigationBarView 底部
            pageViewController.view.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: tabBarView.topAnchor),
        ])
    }

    private func setupPageViewController() {
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([pages[1]], direction: .forward, animated: false)
    }
    
    private func switchToPage(index: Int) {
//        print("currentIndex",index, currentIndex)
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        pageViewController.setViewControllers([pages[index]], direction: direction, animated: true)
        currentIndex = index
        tabBarView.updateSelectedTab(index: index)
    }
}

extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < (pages.count - 1) else { return nil }
        return pages[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: visibleVC) {
            currentIndex = index
            tabBarView.updateSelectedTab(index: currentIndex)
        }
    }
}
