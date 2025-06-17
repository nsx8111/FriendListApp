//
//  FriendViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import UIKit

class FriendViewController: UIViewController {

    private let viewModel = FriendViewModel()
    private let noFriendView = NoFriendView()
    private let noInvitationsView = NoInvitationsView()
    private let invitedFriendView = InvitedFriendView()

    var contentType: MainContentType = .noFriend

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView(for: contentType)
        
        noInvitationsView.onRequestRefresh = { [weak self] in
            self?.setupView(for: .noInvitations)
        }
        invitedFriendView.onRequestRefresh = { [weak self] in
            self?.setupView(for: .invitedFriend)
        }
    }
    
    func setupView(for type: MainContentType) {
        [noFriendView, noInvitationsView, invitedFriendView].forEach {
            $0.removeFromSuperview()
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let urls: [String]

        switch type {
        case .noFriend:
            view.addSubview(noFriendView)
            NSLayoutConstraint.activate([
                noFriendView.topAnchor.constraint(equalTo: view.topAnchor),
                noFriendView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                noFriendView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                noFriendView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            urls = ["https://dimanyen.github.io/friend4.json"]
            viewModel.fetchFriends(urls: urls) { [weak self] friends in
                DispatchQueue.main.async {
                    self?.noFriendView.updateFriendList(friends)
                }
            }
        case .noInvitations:
            view.addSubview(noInvitationsView)
            NSLayoutConstraint.activate([
                noInvitationsView.topAnchor.constraint(equalTo: view.topAnchor),
                noInvitationsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                noInvitationsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                noInvitationsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            urls = ["https://dimanyen.github.io/friend1.json", "https://dimanyen.github.io/friend2.json"]
            viewModel.fetchFriends(urls: urls) { [weak self] friends in
                DispatchQueue.main.async {
                    self?.noInvitationsView.updateFriendList(friends)
                    self?.noInvitationsView.endRefreshing()
                }
            }
        case .invitedFriend:
            view.addSubview(invitedFriendView)
            NSLayoutConstraint.activate([
                invitedFriendView.topAnchor.constraint(equalTo: view.topAnchor),
                invitedFriendView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                invitedFriendView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                invitedFriendView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            urls = ["https://dimanyen.github.io/friend3.json"]
            viewModel.fetchFriends(urls: urls) { [weak self] friends in
                DispatchQueue.main.async {
                    self?.invitedFriendView.updateFriendList(friends)
                    self?.invitedFriendView.endRefreshing()
                }
            }
        }
    }
}
