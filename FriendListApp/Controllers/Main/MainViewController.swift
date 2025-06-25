//
//  MainViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    var viewModel = MainViewModel()
    var mainView: MainView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPageViewController()
        setupEvent()
    }
    
    private func setupView() {
        mainView = MainView()
        view = mainView
    }
    
    private func setupPageViewController() {
        addChild(mainView.pageViewController)
        mainView.pageViewController.didMove(toParent: self)
        mainView.pageViewController.dataSource = self
        mainView.pageViewController.delegate = self
        mainView.pageViewController.setViewControllers([viewModel.pages[1]], direction: .forward, animated: false)
    }
    
    private func setupEvent() {
        mainView.tabBarView.onTabSelected = { [weak self] index in
            self?.switchToPage(index: index)
        }
    }
    
    private func switchToPage(index: Int) {
        let direction: UIPageViewController.NavigationDirection = index > viewModel.currentIndex ? .forward : .reverse
        mainView.pageViewController.setViewControllers([viewModel.pages[index]], direction: direction, animated: true)
        viewModel.currentIndex = index
        mainView.tabBarView.updateSelectedTab(index: index)
    }
}

extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewModel.pages.firstIndex(of: viewController), index > 0 else { return nil }
        return viewModel.pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewModel.pages.firstIndex(of: viewController), index < (viewModel.pages.count - 1) else { return nil }
        return viewModel.pages[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = pageViewController.viewControllers?.first, let index = viewModel.pages.firstIndex(of: visibleVC) {
            viewModel.currentIndex = index
            mainView.tabBarView.updateSelectedTab(index: viewModel.currentIndex)
        }
    }
}
