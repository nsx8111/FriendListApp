//
//  FriendViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import UIKit

class FriendViewController: UIViewController {

    var friendView: UIView?

    func updateFriendView(contentType: MainContentType) {
        // 先移除原本 friendView
        friendView?.removeFromSuperview()

        switch contentType {
        case .noFriend:
            let view = NoFriendView()
            friendView = view
        case .noInvitations:
            let view = NoInvitationsView()
            friendView = view
        case .invitedFriend:
            let view = InvitedFriendView()
            friendView = view
        }

        guard let friendView = friendView else { return }

        view.addSubview(friendView)
        friendView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            friendView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            friendView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}






//class FriendViewController: UIViewController {
//
//    private let viewModel = FriendViewModel()
//    private let noFriendView = NoInvitationsView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupLayout()
//    }
//
//    private func setupLayout() {
//        view.addSubview(noFriendView)
//        noFriendView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            noFriendView.topAnchor.constraint(equalTo: view.topAnchor),
//            noFriendView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            noFriendView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            noFriendView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//}
