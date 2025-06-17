//
//  MainContentManager.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/18.
//

import Foundation

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
