//
//  FriendChatPageViewModel.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/26.
//

import Foundation
import UIKit
// MARK: - FriendChatPageViewModel
class FriendChatPageViewModel {
    
    let friendViewModel = FriendViewModel()
    
    lazy var pages: [UIViewController] = {
        return [FriendViewController(), ChatViewController()]
    }()

    var currentIndex = 0
}
