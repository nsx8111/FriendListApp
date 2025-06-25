//
//  Singleton.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/18.
//

import Foundation
import UIKit

class MainContentManager {
    static let shared = MainContentManager()
    private init() {}
    
    var currentType: MainContentType = .noFriend
}

enum MainContentType {
    case noFriend
    case noInvitations
    case invitedFriend
}


class AppMetrics {
    static var statusBarHeight: CGFloat {
        let windowScene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first

        let window = windowScene?.windows.first
        return window?.safeAreaInsets.top ?? 44
    }
}
