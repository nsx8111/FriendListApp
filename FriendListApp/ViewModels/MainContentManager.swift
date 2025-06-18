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


let apiDatasource1: String = "https://dimanyen.github.io/man.json"
let apiDatasource2: String = "https://dimanyen.github.io/friend1.json"
let apiDatasource3: String = "https://dimanyen.github.io/friend2.json"
let apiDatasource4: String = "https://dimanyen.github.io/friend3.json"
let apiDatasource5: String = "https://dimanyen.github.io/friend4.json"
