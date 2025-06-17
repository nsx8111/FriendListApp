//
//  FriendChatPageViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import Foundation
import UIKit

class FriendChatPageViewController: UIViewController {
    var contentType: MainContentType = .noFriend

    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let navigationBar = NavigationBarView()

    private lazy var pages: [UIViewController] = {
        return [FriendViewController(), ChatViewController()]
    }()

    private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupLayout()
        setupPageViewController()
        if let friendVC = pages[0] as? FriendViewController {
            friendVC.setupView(for: contentType)
        }
    }

    private func setupLayout() {
        [navigationBar, pageViewController.view].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 192),
 
            pageViewController.view.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        navigationBar.friendTabButton.addTarget(self, action: #selector(showFriendPage), for: .touchUpInside)
        navigationBar.chatTabButton.addTarget(self, action: #selector(showChatPage), for: .touchUpInside)
    }

    private func setupPageViewController() {
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)

        pageViewController.dataSource = self
        pageViewController.delegate = self

        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false)
    }

    @objc private func showFriendPage() {
        if currentIndex != 0 {
            pageViewController.setViewControllers([pages[0]], direction: .reverse, animated: true)
            currentIndex = 0
            navigationBar.setSelectedTab(index: currentIndex)
        }
    }

    @objc private func showChatPage() {
        if currentIndex != 1 {
            pageViewController.setViewControllers([pages[1]], direction: .forward, animated: true)
            currentIndex = 1
            navigationBar.setSelectedTab(index: currentIndex)
        }
    }
}

extension FriendChatPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

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
            navigationBar.setSelectedTab(index: currentIndex)
        }
    }
}
