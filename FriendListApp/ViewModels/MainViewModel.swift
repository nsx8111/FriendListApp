//
//  MainViewModel.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/26.
//

import Foundation
import UIKit
// MARK: - MainViewModel
class MainViewModel {
    
    lazy var pages: [UIViewController] = {
        return [
            MoneyViewController(),
            FriendChatPageViewController(),
            KOKOViewController(),
            AccountingViewController(),
            SettingViewController()
        ]
    }()
    
    var currentIndex = 0
}
